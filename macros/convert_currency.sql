{#
  convert_currency

  Converts a monetary amount from its source currency (stored in a column) to a target currency
  using precomputed exchange rates from the util__rates model.

  Parameters:
  - column_name: SQL expression for the amount to convert (e.g., 'amount' or 't.amount').
  - target_currency: Target currency code, one of ['CZK','EUR','USD','HUF'].
  - currency_column: Column that contains the source currency code (default 'system_currency').
  - convert_from: List of allowed currency codes.

  Example usage:
  select
    {{ convert_currency('t.amount', 'EUR', currency_column='t.currency') }} as amount_eur
  from my_table t
  left join {{ ref('util__rates') }} as r
    on r.date_day = t.date_day
#}
{% macro convert_currency(column_name, target_currency, convert_from=['CZK', 'EUR', 'USD', 'HUF'], currency_column='currency') %}

{%- set target_upper = target_currency | upper -%}
{%- set convert_from_upper = convert_from | map('upper') | list -%}

{%- if target_upper not in convert_from_upper -%}
    {{ exceptions.raise_compiler_error("Invalid target currency '" ~ target_currency ~ "'. Must be one of: " ~ (convert_from | join(', '))) }}
{%- endif -%}

case
{%- for currency in convert_from_upper %}
    when {{ currency_column }} = '{{ currency }}' then
        {% if currency == target_upper -%}
            coalesce({{ column_name }}, 0)
        {% else -%}
            coalesce({{ column_name }}, 0) * coalesce({{ currency | lower }}_to_{{ target_upper | lower }}, 0)
        {%- endif -%}
{%- endfor %}
    else 0
end

{%- endmacro %}