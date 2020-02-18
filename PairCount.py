from mrjob.job import MRJob
from mrjob.step import MRStep

## Creating Map Reduce Job for HW1 in CS626 using MRJOB
class myFirstMR(MRJob):
    def steps(self):
        return [
            MRStep(mapper=self.mapper_get_unique_pairs,
                   reducer=self.reducer_count_combos)  # Come back and place in the mapper and reducer)

        ]
# Here I order each pair of the data from the CSV file.

    def mapper_get_unique_pairs(self, _, line):
        pair = line.split(',')
        if pair[1] > pair[0]:
            pair[0], pair[1] = pair[1], pair[0]
       # (c1, c2) = line.split(',')
        yield (pair, 1)
# Sum up the number of occurances for each unique pair 
    def reducer_count_combos(self, pair, values):
        yield pair, sum(values)

## Just so it only runs if I am directly running this script
if __name__ == '__main__':
    myFirstMR.run()
