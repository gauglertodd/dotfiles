def getLargest(nums):
    localMax = None
    totalMax = None

    for num in nums:
        if localMax:
            if num > localMax + num:
                localMax = num
            else:
                localMax += num
        else:
            localMax = num

        totalMax = max(totalMax if totalMax is not None else localMax, localMax)
        print(f"local max, total max: {localMax}, {totalMax}")
    return totalMax


# getLargest([-1,0,-2])

d1 = {1: 'f', 2: 'g', 3: 'h'}
d2 = {1: 'a', 2: 'b', 3: 'c'}


def getItem(index):
    return d1[index], d2[index]


class A:

    def __iter__(self):
        for i in [1, 2, 3]:
            yield getItem(i)


import pdb
pdb.set_trace()
