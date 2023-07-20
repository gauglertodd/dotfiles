class Solution:
    def findMin(self, nums: List[int]) -> int:
        l = 0
        r = len(nums)- 1

        while l < r:
            mid = (l+r) // 2
            
            if nums[mid] < nums[right]:
                r = mid
            elif:
                nums[mid] > nums[right]:
                l = mid + 1
            else:
                return min(findmin(nums[0:mid]), findmin(nums[mid:]))
        
        return nums[l]

        