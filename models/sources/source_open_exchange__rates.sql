with source as (

    select *
    from {{ source('open_exchange', 'rates') }}
),

final as (

    select
        {{ adapter.quote('date') }} as date_day,
        base as base_currency,
        eur,
        usd,
        huf

    from source
)

select * from final