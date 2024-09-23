@outputSchema("result:tuple(region:chararray, gold:int, silver:int)")
def fill_missing_silver(region, gold, silver):
    if silver is None:
        silver = 0
    return (region, gold, silver)
