with source as (

    select *
    from {{ ref('source_open_exchange__rates') }}
),

final as (

    select
        date_day,
        round(usd, 4) as czk_to_usd,
        round(eur, 4) as czk_to_eur,
        round(huf, 4) as czk_to_huf,
        round(1 / usd, 4) as usd_to_czk,
        round(1 / eur, 4) as eur_to_czk,
        round(1 / huf, 4) as huf_to_czk,
        round(eur / usd, 4) as usd_to_eur,
        round(usd / eur, 4) as eur_to_usd,
        round(huf / usd, 4) as usd_to_huf,
        round(usd / huf, 4) as huf_to_usd,
        round(huf / eur, 4) as eur_to_huf,
        round(eur / huf, 4) as huf_to_eur

    from source
)

select * from final