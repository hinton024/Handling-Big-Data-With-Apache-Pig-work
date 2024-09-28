@outputSchema("region:chararray, gold:int, silver:int")
def add_zero(gold_region, silver_region, gold, silver):
    # Handle region: use gold_region if not None, otherwise use silver_region
    region = gold_region if gold_region is not None else silver_region
    
    # Handle gold: use gold if not None, otherwise use 0
    gold_count = gold if gold is not None else 0
    
    # Handle silver: use silver if not None, otherwise use 0
    silver_count = silver if silver is not None else 0
    
    # Ensure gold and silver are integers
    gold_count = int(gold_count)
    silver_count = int(silver_count)
    
    return (region, gold_count, silver_count)