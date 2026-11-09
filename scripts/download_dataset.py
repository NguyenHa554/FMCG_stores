"""Download and safely extract the full CSV dataset used by release builds."""

import argparse
import hashlib
import os
import re
import shutil
import tempfile
import urllib.error
import urllib.parse
import urllib.request
import zipfile
from pathlib import Path

EXPECTED_FILES = {
    "sales.csv",
    "products.csv",
    "categories.csv",
    "customers.csv",
    "cities.csv",
    "countries.csv",
    "employees.csv",
}
MAX_DOWNLOAD_BYTES = 1_500_000_000
MAX_UNCOMPRESSED_BYTES = 2_000_000_000
CHUNK_SIZE = 1024 * 1024


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output-dir", required=True, type=Path)
    return parser.parse_args()


def require_configuration() -> tuple[str, str]:
    url = os.environ.get("FMCG_DATASET_URL", "")
    checksum = os.environ.get("FMCG_DATASET_SHA256", "").strip().lower()

    if urllib.parse.urlparse(url).scheme != "https":
        raise SystemExit("FMCG_DATASET_URL must be a non-empty HTTPS URL")
    if not re.fullmatch(r"[0-9a-f]{64}", checksum):
        raise SystemExit("FMCG_DATASET_SHA256 must contain 64 hexadecimal characters")
    return url, checksum


def download(url: str, destination: Path) -> str:
    request = urllib.request.Request(url, headers={"User-Agent": "fmcg-ci/1.0"})
    digest = hashlib.sha256()
    downloaded = 0
    try:
        with urllib.request.urlopen(request, timeout=60) as response:
            if urllib.parse.urlparse(response.geturl()).scheme != "https":
                raise RuntimeError("dataset URL redirected to a non-HTTPS location")
            content_length = response.headers.get("Content-Length")
            if content_length and int(content_length) > MAX_DOWNLOAD_BYTES:
                raise RuntimeError("dataset archive exceeds the 1.5 GB download limit")
            with destination.open("wb") as output:
                while chunk := response.read(CHUNK_SIZE):
                    downloaded += len(chunk)
                    if downloaded > MAX_DOWNLOAD_BYTES:
                        raise RuntimeError("dataset archive exceeds the 1.5 GB download limit")
                    digest.update(chunk)
                    output.write(chunk)
    except (OSError, RuntimeError, urllib.error.URLError) as exc:
        raise SystemExit(
            "Dataset download failed; verify the URL, permissions, and file size"
        ) from None

    return digest.hexdigest()


def validate_archive(archive: zipfile.ZipFile) -> dict[str, zipfile.ZipInfo]:
    members: dict[str, zipfile.ZipInfo] = {}
    total_size = 0
    for member in archive.infolist():
        if member.is_dir():
            continue
        name = member.filename
        if "/" in name or "\\" in name or name not in EXPECTED_FILES:
            raise RuntimeError(
                "archive must contain only the seven expected CSV files at its root"
            )
        if name in members:
            raise RuntimeError(f"archive contains duplicate file: {name}")
        total_size += member.file_size
        if total_size > MAX_UNCOMPRESSED_BYTES:
            raise RuntimeError("uncompressed dataset exceeds the 2 GB limit")
        members[name] = member

    missing = sorted(EXPECTED_FILES - members.keys())
    if missing:
        raise RuntimeError(f"archive is missing: {', '.join(missing)}")
    return members


def main() -> None:
    args = parse_args()
    url, expected_checksum = require_configuration()
    output_dir = args.output_dir.resolve()
    output_dir.parent.mkdir(parents=True, exist_ok=True)
    if output_dir.exists():
        raise SystemExit(f"Output directory already exists: {output_dir}")

    with tempfile.TemporaryDirectory(
        prefix="fmcg-dataset-", dir=output_dir.parent
    ) as temp_name:
        temp_dir = Path(temp_name)
        archive_path = temp_dir / "dataset.zip"
        actual_checksum = download(url, archive_path)
        if actual_checksum != expected_checksum:
            raise SystemExit(
                "Dataset checksum mismatch; update the configured checksum only after "
                "verifying the source archive"
            )

        extracted = temp_dir / "extracted"
        extracted.mkdir()
        try:
            with zipfile.ZipFile(archive_path) as archive:
                members = validate_archive(archive)
                for name, member in members.items():
                    with archive.open(member) as source, (extracted / name).open("wb") as dest:
                        shutil.copyfileobj(source, dest, length=CHUNK_SIZE)
        except (OSError, RuntimeError, zipfile.BadZipFile):
            raise SystemExit(
                "Dataset archive is invalid; expected a ZIP containing seven CSV files"
            ) from None

        shutil.move(str(extracted), str(output_dir))

    print(f"Verified and extracted {len(EXPECTED_FILES)} dataset files")


if __name__ == "__main__":
    main()
