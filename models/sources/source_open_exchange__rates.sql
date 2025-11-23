with source as (

    select *
    from {{ source('open_exchange', 'rates') }}
),

final as (

    select
        {{ adapter.quote('date') }} as date_day,
        base as base_currency,
        rates__eur as eur,
        rates__usd as usd,
        rates__huf as huf,
        rates__gbp as gbp,
        rates__pln as pln

    from source
)

select * from final