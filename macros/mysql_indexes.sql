{% macro mysql_create_index_if_not_exists(source_name, table_name, index_name, columns) %}
    {% if target.type != 'mysql' %}
        {{ return('select 1') }}
    {% endif %}

    {% set source_relation = source(source_name, table_name) %}

    {% if execute %}
        {% set index_exists_sql %}
            select count(*)
            from information_schema.statistics
            where table_schema = '{{ source_relation.schema }}'
              and table_name = '{{ source_relation.identifier }}'
              and index_name = '{{ index_name }}'
        {% endset %}

        {% set result = run_query(index_exists_sql) %}
        {% set index_exists = result.columns[0].values()[0] | int %}

        {% if index_exists == 0 %}
            {% do run_query(
                'create index ' ~ index_name ~
                ' on ' ~ source_relation ~
                '(' ~ columns ~ ')'
            ) %}
        {% endif %}
    {% endif %}

    {{ return('select 1') }}
{% endmacro %}

{% macro mysql_create_model_index_if_not_exists(index_name, columns) %}
    {% if target.type != 'mysql' %}
        {{ return('select 1') }}
    {% endif %}

    {% if execute %}
        {% set index_exists_sql %}
            select count(*)
            from information_schema.statistics
            where table_schema = '{{ this.schema }}'
              and table_name = '{{ this.identifier }}'
              and index_name = '{{ index_name }}'
        {% endset %}

        {% set result = run_query(index_exists_sql) %}
        {% set index_exists = result.columns[0].values()[0] | int %}

        {% if index_exists == 0 %}
            {% do run_query(
                'create index ' ~ index_name ~
                ' on ' ~ this ~
                '(' ~ columns ~ ')'
            ) %}
        {% endif %}
    {% endif %}

    {{ return('select 1') }}
{% endmacro %}
