## Uses MPJob to take two columns of data, R and L,  and compute the set difference R – L,
##that is, the set of strings appearing in the second components of the pairs but not appearing in the first components of the pairs.

## probably a better way of doing this
from mrjob.job import MRJob
from mrjob.step import MRStep
import functools


class myFirstMR(MRJob):
    def steps(self):
        return [
            MRStep(mapper=self.mapper_get_column_keys,
                   combiner=self.combinerz,

                   reducer=self.reducer_count_combos)  # Come back and place in the mapper and reducer)

        ]

    def mapper_get_column_keys(self, _, line):
        # This splits the line  by commas, and stores it in a list
        pair = line.split(',')
        self.increment_counter('Map', 'Number of Lines ', 1)
        yield (pair[1], 1)  # Assigns a <k,v> pair for column R, with 1 indicating it is in R 
        yield (pair[0], 0). # Assigns a <k,v> pair for column L, with 0 indicating it is in L

    def combinerz(self, key, values):
    # Probably a better way to do this, but I just reduce each set of value so that if there's any instance in column L, the value becomes zero.
        value = functools.reduce((lambda x, y, : x*y), values) 

        yield (key, value)

    def reducer_count_combos(self, key, value):
        self.increment_counter('Reduce', 'Number of Unique L ', 1)
        for v in value:
            if v != 0:
            ## Only yield the key values where v is postive, thus not in L.
                yield key, v

        # This counts the number of each set


if __name__ == '__main__':
    myFirstMR.run()
