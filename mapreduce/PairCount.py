from mrjob.job import MRJob
from mrjob.step import MRStep
import re

Word_RE = re.compile(r"[\w']+")


class myFirstMR(MRJob):
    def steps(self):
        return [
            MRStep(mapper=self.mapper_get_unique_pairs,
                   reducer=self.reducer_count_combos) 

        ]

    def mapper_get_unique_pairs(self, _, line):
        pair = Word_RE.findall(line)
        if pair[1] > pair[0]:
            pair[0], pair[1] = pair[1], pair[0]

       # (c1, c2) = line.split(',')
        yield (pair, 1)

     #   for word in Word_RE.findall(line):
     #       yield (word.lower(), 1)

    def reducer_count_combos(self, pair, values):
        self.increment_counter('group', 'unique pairs', 1)
        yield pair, sum(values)


if __name__ == '__main__':
    myFirstMR.run()
