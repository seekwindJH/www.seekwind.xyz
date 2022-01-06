---
title: Binary Search
date: 2021-12-18T12:04:30+08:00
draft: false
categories:
    - algorithms
tags:
    - array
    - search
---

二分搜索的思路并不复杂。想要正确处理一个二分搜索，关键在于区间端点的变化、循环终止条件。掌握好这些后，想要正确处理一个二分搜索，轻而易举。

<!--more-->

二分搜索，通常以在有序单个一维数组中**查找指定元素**为背景。

## 1. 在单个一维数组中查找指定元素

先看最经典的二分搜索。给定一个升序数组nums，其中的每个元素都是唯一的，请在该数组nums中查找指定元素target的下标，若找不到，则返回-1。

```java
public void binarySearch(int[] nums, int target) {
    int left = 0;
    int right = nums.length - 1;
    // 循环条件是<=，等于号不能忽略
    while (left <= right) {
        int mid = (left + right) >> 1;
        if (nums[mid] == target) {
            return mid;
        }
        else if (nums[mid] > target) {
            // 区间端点的变化十分简单
            // 每次区间收缩都会舍去半个区间+mid元素
            // 因为mid元素肯定不是答案。
            right = mid - 1;
        }
        else {
            left = mid + 1;
        }
    }
    return -1;
}
```

这题是最经典、最简单的二分搜索例题。根据这道例题，我们适当放宽条件，会得到如下几种变式。

### 1. 元素可以重复出现

上面的题目中，每个元素是唯一的，查找起来特别方便，只要找到了就返回。当元素可以重复出现时，我们要返回的是**target元素出现的次数**或者**target元素出现的区间**。

事实上，这道题说白了，就是找target**第一次出现的位置**和**最后一次出现的位置**。而这两个位置，可以用两次二分查找获得。两次二分查找唯一的不同点，在于**区间收缩的判断条件**。

```java
class Solution {
    public int[] searchRange(int[] nums, int target) {
        int leftRange = binarySearch(nums, target, true);
        int rightRange = binarySearch(nums, target, false);
        // 第三个细节：leftRange > rightRange，说明数组中不存在target。
        // 因为下面while的终止条件就是这么规定的。
        return leftRange > rightRange ? 
            new int[] {-1, -1} : 
            new int[] {leftRange, rightRange};
    }
    private int binarySearch(int[] nums, int target, boolean isLeft) {
        int left = 0;
        int right = nums.length - 1;
        while (left <= right) {
            int mid = (left + right) >> 1;
            // 第一个细节：||后面的条件，在isLeft为true时才有判断的意义
            if (nums[mid] > target || (isLeft && nums[mid] == target)) {
                right = mid - 1;
            }
            else {
                left = mid + 1;
            }
        }
        // 第二个细节
        return isLeft ? left : right;
    }
}
```

如果要得到target出现的次数，只要将返回值改为`rightRange - leftRange + 1`即可。

### 2. 旋转数组

旋转数组，也就是将原来的数组平移，类似循环队列的操作。例如，数组`[1, 2, 3, 4, 5]`向右旋转两个单位，得到`[4, 5, 1, 2, 3]`。我们要求在**旋转无重复数组**中寻找指定元素。

经过仔细观察，我们可以发现旋转数组有一个神奇的特点。如果我们将旋转数组从中间切一刀，划分成两半，那么必定有一半是有序数组，另一半还是旋转数组。
1. 如果target在有序数组的范围内，那么在有序数组中进行二分查找。
2. 如果target不在有序数组范围内，那么在旋转数组中继续进行上述操作。

```java
class Solution {
    public int search(int[] nums, int target) {
        int left = 0;
        int right = nums.length - 1;
        while (left <= right) {
            int mid = (left + right) >> 1;
            // 左侧是有序数组
            if (nums[left] <= nums[mid]) {
                if (nums[left] <= target && target <= nums[mid]) {
                    // target在左侧数组范围内二分
                    return binarySearch(nums, target, left, mid);
                }
                // 如果不在左侧数组范围内，则将左侧数组全部舍去
                left = mid + 1;
            } 
            // 右侧是有序数组
            else {
                if (nums[mid] <= target && target <= nums[right]) {
                    // target在右侧数组范围内二分
                    return binarySearch(nums, target, mid, right);
                }
                // 如果不在右侧数组范围内，则将右侧数组全部舍去
                right = mid - 1;
            }
        }
        return -1;
    }

    // 二分查找
    private int binarySearch(int[] nums, int target, int left, int right) {
        while (left <= right) {
            int mid = (left + right) >> 1;
            if (nums[mid] == target) {
                return mid;
            }
            else if (nums[mid] > target) {
                right = mid - 1;
            }
            else {
                left = mid + 1;
            }
        }
        return -1;
    }
}
```

在一个数组中查找元素，变来变去也就一点花样。因此，下面讲一讲在多个数组中查找元素的案例。

## 2. 在多个数组中二分查找

### 1. 矩阵中查找

这道题来自于[LeetCode 240](https://leetcode-cn.com/problems/search-a-2d-matrix-ii/)。
在一个m*n的矩阵中，每一行每一列都是递增的，但是，并不保证上一行的每个元素小于下一行的每个元素。例如

```
1 4 7
2 5 8
3 6 9
```

矩阵中的每一个元素都是唯一的。我们要在矩阵中查找指定元素target。

与传统的二分搜索不同的是，我们并不是使用常规的方法来折半切割数组。而是使用下面这种方式来切割。例如，在上面的矩阵中，假设我们要寻找数组2，那么，我们可以从7开始查找。
1. 7比2要大，而7是该列最小的元素，那么这一列被划去。我们跳到4。
2. 4比2要大，而4是该列最小的元素，那么这一列被划去。我们跳到1。
3. 1比2要小，因此我们要向下或向右，然而我们原来就从右边过来的，所以这次向下跳到2，直接找到target。

综上所述，从右上角开始：
* 如果当前元素比target大，则向左移动
* 如果当前元素比target小，则向右移动

只要target出现在矩阵中，那么这样肯定是可以找到的，而且最坏情况下的时间复杂度也仅为$O(m+n)$。

```java
class Solution {
    public boolean searchMatrix(int[][] matrix, int target) {
        int m = matrix.length;
        int n = matrix[0].length;
        int i = 0;
        int j = n - 1;

        while (i < m && j >= 0) {
            int cur = matrix[i][j];
            if (cur == target) {
                return true;
            }
            if (cur > target) {
                j --;
            } else {
                i ++;
            }
        }
        return false;
    }
}
```

事实上，二分搜索与AVL树有着隐含的联系。例如AVL树高为log级别的，而二分的查找效率一般也为log级别的（这题除外）。我们发现，当前元素要么向下跳，要么向左跳，与AVL树的向左向右查找十分相似。进一步的，我们惊人的发现，如果将矩阵沿着右上角向左下角展开，竟然就是AVL树。

### 2. 在两个数组中查找

两个数组都是有序数组，而且数组的元素不重复。请写出两个数组所有元素的中位数。这题来自于[LeetCode 4](https://leetcode-cn.com/problems/median-of-two-sorted-arrays/)相当费解。

```java
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        if (nums1.length > nums2.length) {
            return findMedianSortedArrays(nums2, nums1);
        }

        int len1 = nums1.length;
        int len2 = nums2.length;

        int left = 0, right = len1;

        int mid1 = 0 , mid2 = 0;

        while (left <= right) {
            // i 用于划分nums1
            int i = (left + right) / 2;
            // j 用于划分nums2
            int j = (len1 + len2 + 1) / 2 - i;
            // j经过这种计算，能够保证nums1左半边数组长度+nums2左半边数组长度等于总长度的一半
            
            
            int nums1Left = i == 0 ? Integer.MIN_VALUE : nums1[i - 1]; // 计算nums1左侧最大
            int nums1Right = i == len1 ? Integer.MAX_VALUE : nums1[i]; // 计算nums1右侧最小
            int nums2Left = j == 0 ? Integer.MIN_VALUE : nums2[j - 1];
            int nums2Right = j == len2 ? Integer.MAX_VALUE : nums2[j];

            // 由于nums1比nums2短，则如果满足下面if，则nums1左半部分一定舍弃
            // 需要注意的是，j是通过i计算得到的
            // 因此，对left做移动，相当于对i做移动，而对i做移动又相当于对j做移动
            // 因此nums2的j指针实际上也移动了
            if (nums1Left <= nums2Right) {
                // mid1记录左侧最大值
                mid1 = Math.max(nums1Left, nums2Left);
                // mid2记录右侧最小值
                mid2 = Math.min(nums1Right, nums2Right);
                left = i + 1;
            } else {
                right = i - 1;
            }
        }
        return (len1 + len2) % 2 == 0 ?  (mid1 + mid2) / 2.0 : mid1;
    }
}
```

很多时候，我们并不是直接使用二分查找求解，而是将二分查找作为求解的中间过程。

## 3. 使用二分查找作为中间过程

这题来自于[LeetCode 31 下一个排列](https://leetcode-cn.com/problems/next-permutation/)。给定一个int数组，求该数组的下一个字典序排列。

例如，[1, 2, 3]的下一个字典序是[1, 3, 2]。而[3, 2, 1]的下一个字典序是[1, 2, 3]。

经过仔细分析，我们发现，数组的字典序与我们往常缩减到的数字一样，也是高位在左，低位在右。那么，我们要优先改动低位，才能保证得到的字典序是下一个序列。所以，其实很简单：
 1. 从右向左遍历，找到第一个数字满足条件的数字，使得从右向左遍历的顺序不是非降序的。记这个数字的下标为i。
 2. 在i+1到length-1这部分数组中，寻找比下标为i的数字大的数字的最小值，将其与i替换。该查找过程使用二分搜索。
 3. 将i+1至length-1部分的数组翻转。

其实道理很简单，我们一想就能想明白。讲究的就是优先改动右侧低位。

```java
class Solution {
    public void nextPermutation(int[] nums) {
        int i = nums.length - 2;
        // 完成步骤1，寻找第一个非降序的数字
        while (i >= 0 && nums[i] >= nums[i + 1]) {
            i --;
        }

        if (i > -1) {
            // 完成步骤2，二分查找
            int left = i + 1;
            int right = nums.length - 1;
            // 注意循环条件，我们要让循环能够正常跳出，而不是死循环，因此减1很有必要
            while (left < right - 1) {
                int mid = (left + right) >> 1;
                if (nums[i] < nums[mid]) {
                    left = mid;
                } else {
                    right = mid;
                }
            }
            if (nums[right] > nums[i]) {
                left = right;
            }
            // 与i替换
            int t = nums[left];
            nums[left] = nums[i];
            nums[i] = t;
        }
        // 完成步骤3，翻转i+1至结尾
        reverse(nums, i + 1, nums.length - 1);
    }

    private void reverse(int[] nums, int left, int right) {
        for (int j = 0 ; (j << 1) + left <= right ; j ++) {
            int t = nums[left + j];
            nums[left + j] = nums[right - j];
            nums[right - j] = t;
        }
    }
}
```