## Instructions to Run the Pig Scripts on AWS EMR

### Prerequisites:
- Ensure that the input files (noc_region.csv, person_region.csv, person.csv, competitor_event.csv, medal.csv) are uploaded to the HDFS directory `/input/` on AWS EMR.
- The output for each task will be written to `/output/task1`, `/output/task2-1`, and `/output/task2-2` respectively.

### Steps:

1. **Task 1:**
   - Upload the file `task1.pig` to your AWS EMR cluster.
   - Run the following command to execute the Pig script:
     ```
     pig -f task1.pig
     ```

2. **Task 2.1:**
   - Upload the file `task2-1.pig` to your AWS EMR cluster.
   - Run the following command to execute the Pig script:
     ```
     pig -f task2-1.pig
     ```

3. **Task 2.2 (with UDF):**
   - Upload both `task2-2.pig` and `task2udf.py` to your AWS EMR cluster.
   - Run the following command to execute the Pig script:
     ```
     pig -f task2-2.pig
     ```

### File Structure:
- Input files should be located in `/input/` on HDFS:
  -
