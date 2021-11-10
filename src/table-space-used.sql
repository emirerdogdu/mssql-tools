SELECT 
    SUM(CONVERT (Decimal(15,2),ROUND(a.Size/128.000,2))) [Currently Allocated Space (MB)],
    SUM(CONVERT (Decimal(15,2), ROUND(FILEPROPERTY(a.Name,'SpaceUsed')/128.000,2))) AS [Space Used (MB)],
    SUM(CONVERT (Decimal(15,2),ROUND((a.Size-FILEPROPERTY(a.Name,'SpaceUsed'))/128.000,2))) AS [Available Space (MB)],
    ((SUM(CONVERT (Decimal(15,2),ROUND((a.Size-FILEPROPERTY(a.Name,'SpaceUsed'))/128.000,2)))*100) / SUM(CONVERT (Decimal(15,2),ROUND(a.Size/128.000,2)))) as [Available Space Ratio]
FROM dbo.sysfiles a (NOLOCK)
JOIN sysfilegroups b (NOLOCK) ON a.groupid = b.groupid