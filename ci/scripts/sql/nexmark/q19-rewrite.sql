-- noinspection SqlNoDataSourceInspectionForFile
-- noinspection SqlResolveForFile
CREATE SINK nexmark_q19_rewrite AS
SELECT auction, bidder, price, channel, url, date_time, extra, ROW_NUMBER() over (PARTITION BY auction ORDER BY price DESC) as rank_number
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY auction ORDER BY price DESC) AS rank_number
    FROM bid
) Q
WHERE Q.rank_number <= 10
WITH ( connector = 'blackhole', type = 'append-only', force_append_only = 'true');
