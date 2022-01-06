---
title: Array
date: 2021-12-13T12:17:46+08:00
weight: 1
tags:
    - array
    - dp
categories:
    - algorithms
---

数组类型的题目，通常只需要进行一次遍历。掌握其中的技巧后，这类题目十分简单。

<!--more-->

我们先来看一组**负号标记法**类型的题目（不是头顶标记法😢）。

## 1. 负号标记法

负号标记法的题目都有一类显著的特征：

- **第一类特征**：数字的取值都在0至nums.length-1之间。
- **第二类特征**：数字的取值有部分不在0至nums.length之间，而这部分不在区间内的数字，往往忽略后也不会影响结果。

### 1. LeetCode448.找到所有数组中消失的数字

看下面这道例题，这道题来自于[LeetCode448.找到所有数组中消失的数字](https://leetcode-cn.com/problems/find-all-numbers-disappeared-in-an-array/)。

给定一个长度为n的数组，数组元素的值全部位于闭区间`[1, n]`内。但是其中有重复出现的数字，因此导致了闭区间`[1, n]`内有的数字始终没有出现过。请找出这些没出现过的数字。

例如: 数组`nums = [2,1,3,3,3]`，其中数字4和5在闭区间`[1, 5]`内，但没有出现在数组中。因此我们需要返回4和5两个数构成的数组。

分析：数组的特征满足上面所提到的**第一类特征**。因此可以使用负号标记法。该如何标记呢？很简单。我们从左到右遍历数组nums，例如上面的例子数组。

1. 当访问第一个元素2时，我们把nums的第`(2-1)`个元素标记上负号。此时，数组变成了`nums = [2,-1,3,3,3]`。
2. 当访问第二个元素-1时，很明显，负号是我们之前标上去的，要还原出原来的数字，只需要取绝对值1。我们把nums的第`(1-1)`个元素标记上负号。此时，数组变成了`nums = [-2,-1,3,3,3]`
3. 同理，第三次操作后，数组变成了`nums = [-2,-1,-3,3,3]`。
4. 事情在第四次操作迎来了转机。我们要将第2个元素标上负号，可是此时已经有负号了，那么就不需要再标记负号了，因为负负得正。

最终，我们得到了数组`nums = [-2,-1,-3,3,3]`。此时，我们就发现负号的作用了。在位置i标记一个负号，相当于数字i+1出现过了。数组中0、1、2的位置标上了负号，说明1、2、3这三个数字出现过了。而3、4两个下标的元素却没有标记负号，说明4、5两个数字没有出现过。所以答案就得到了。

```java
class Solution {
    public List<Integer> findDisappearedNumbers(int[] nums) {
        // 第一次遍历，标记出现过的数字
        for (int num : nums) {
            int index = Math.abs(num) - 1;
            if (nums[index] > 0) {
                // 已经有负号则不需要标记，正数才要标记
                nums[index] = -nums[index];
            }
        }
        List<Integer> ans = new LinkedList<>();
        // 第二次遍历，寻找所有没标记负号的数字
        for (int i = 0 ; i < nums.length ; i ++) {
            if (nums[i] > 0) {
                ans.add(i + 1);
            } else {
                // 作为一个有素质的程序员，我们要还原数组
                nums[i] = -nums[i];
            }
        }
        return ans;
    }
}
```

这道题目被LeetCode标记为**简单**。然而下面笔者要讲的这题，与本题十分相似，却被LeetCode认为是**困难**，我认为不可思议。

### 2. LeetCode41.缺失的第一个正数

这道题是[LeetCode41.缺失的第一个正数](https://leetcode-cn.com/problems/first-missing-positive/)。

依然是给定一个长度为n的数组。与上题不同的是，数组的元素取值是任意的整数，可正可负可零。我们要找到最小的未出现的正整数。

例如，数组`nums = [3,4,-1,1]`中，未出现的最小正数是2。

分析：元素的取值区间变化了，尤其是负数比较讨厌。我们本来就需要用负号作为标记，它原数组中已经有负号了，那我们直接用负号标记法肯定是不行的。

经过一番纠结，我们可以发现，负数的存在跟答案是没有关系的，它符合上面指出的**第二类特征**我们很快能想到，将非正数（负数和0）修改成nums.length+2，因为大于nums.length+1的数，与答案也是无关的，毕竟数字一共只有nums.length个，最小未出现的正数，至多不过nums.length+1。

因此，经过一番转换之后，这题与上题就没有区别了。

```java
class Solution {
    public int firstMissingPositive(int[] nums) {
        // 第一次遍历：非正数的修改
        for (int i = 0 ; i < nums.length ; i ++) {
            if (nums[i] <= 0) {
                nums[i] = nums.length + 2;
            }
        }
        // 第二次遍历：负号标记法
        for (int num : nums) {
            int index = Math.abs(num) - 1;
            if (index < nums.length && nums[index] > 0) {
                nums[index] = -nums[index];
            }
        }
        // 第三次遍历：找出正数
        for (int i = 0 ; i < nums.length ; i ++) {
            if (nums[i] > 0) {
                return i + 1;
            }
        }
        // 再不济，答案也不过nums.length+1
        return nums.length + 1;
    }
}
```

细心的读者可能注意到了，这个算法中，我们并没有还原原数组。原因如下：LeetCode剑指Offer03数组中重复的数字

- 题目没有要求。
- 如果需要还原，则另外需要使用一个HashMap记录修改的负数，占用了额外的空间。

逐渐领悟到负号标记法的作用后，我们很容易想到，它还可以为我们寻找数组中重复出现过的数字。当我们第一次标负号时，意味着这个数字第一次出现，当我们第二次标记负号时，意味着这个数字之前已经出现过了，即重复的数字。

这不，[LeetCode剑指Offer03数组中重复的数字](https://leetcode-cn.com/problems/shu-zu-zhong-zhong-fu-de-shu-zi-lcof/)又送上门来了？

### 3. LeetCode剑指Offer03数组中重复的数字

这次还是一个长度为n的数组，数字的取值在闭区间`[0,n-1]`内。请找出重复出现的数字，找出任意一个就算成功。

例如，`nums = [2,3,1,0,2,5,3]`，答案可以是2或者3。

不用多说，满足**第一类特征**。这道题被标记为**简单**也算是实至名归。唯一值得注意的是元素0。因为给0标上0还是0，所以我们需要对0做特殊处理。当希望在0前面标记负号时，我们直接把它改成-nums.length，修改成这个负数，有利于在if中统一处理重复情况，也不会与其他数加负号后相撞。

```java
class Solution {
    public int findRepeatNumber(int[] nums) {
        for (int num : nums) {
            // 对0需要的特殊处理
            int index = num == -nums.length ? 0 : Math.abs(num);
            if (nums[index] < 0) {
                return index;
            }
            else {
                // 0加负号没用，直接改成-nums.length
                nums[index] = nums[index] == 0 ? -nums.length : -nums[index];
            }
        }
        return -1;
    }
}
```

在数组中使用**动态规划**算法，来实现一次遍历，也是常用的方法。

## 2. 动态规划

下面这道题来自于[LeetCode169.多数元素](https://leetcode-cn.com/problems/majority-element/)，如果平时没有做过，第一次做可能会一头雾水，但是做过一遍后就再也不会错了。

### 1. LeetCode169.多数元素

给定一个长度为n的数组，其中的数字取值区间任意。其中，有一个数字，出现的次数超过了半个数组。求这个数。

例如，数组`nums = [3,2,3]`中，3出现了两次，因此我们要返回3。

分析：多数元素，也就是超过半数的元素，也就是说，**其他所有元素的总数**也没有**它的总数**多。我们不妨设置一个**计数器**和一个**目前的多数元素**。依次从左向右遍历。

- 每当出现一个目前的多数元素，则将计数器+1，否则将计数器-1。
- 当计数器减到0时，更换目前的多数元素为现在便利到的元素。

```java
class Solution {
    public int majorityElement(int[] nums) {
        int count = 1;
        int ans = nums[0];
        for (int i = 1 ; i < nums.length ; i ++) {
            // 计数器操作
            count += (ans == nums[i] ? 1 : -1);
            if (count <= 0) {
                // 替换目前的多数元素
                ans = nums[i];
                count = 1;
            }
        } 
        return ans;
    }
}
```

严格的说，这种方法属于动态规划，当遍历到第i个元素时，我们就获得了子数组0~i的该问题的解。掌握这种方法，以后不再出错。

下面这道题比该题略显复杂，官方难度为**中等**，但不需要怕。它依然属于动态规划的思想。

### 2. LeetCode581.最短无序连续子数组

这道题来自于[LeetCode581.最短无序连续子数组](https://leetcode-cn.com/problems/shortest-unsorted-continuous-subarray/)。

又是给定一个int数组。这个数组本来是升序的，但是其中又一段连续的区间被打乱了。我们要找到这段连续区间，并求出这个连续区间的最小长度。

例如，`nums = [2,6,4,8,10,9,15]`，我们只需要把`[6,4,8,10,9]`进行排序，这个数组就升序了。因此答案是5。

分析：怎么找呢？其实把这个问题分解一下，我们要分别寻找左边界与右边界。先考虑左边界。从右向左遍历：我们记录当前所碰到的最小的数min。如果当前碰到的数字小于min，那么当前数字可能成为左边界的候选人，则更新左边界为当前下标。在完成一次遍历后，左边界已经找到。再进行一次从左向右的遍历，找到右边界即可。

算法思路如下：

- 初始化左右边界为不合理的值，例如`left=-1`,`right=-2`，它恰好指向了一个长度为0的不合理区间。
- 从左向右遍历：维护至今为止遇到的最大值，如果当前数字小于最大值，则更新右边界为当前数字。
- 从右向左遍历：维护至今为止遇到的最小值，如果当前数字小于最小值，则更新左边界为当前数字。

两个方向的遍历并没有依赖关系，所以可以在一次循环中同时处理，缩短为一次遍历。

```java
class Solution {
    public int findUnsortedSubarray(int[] nums) {
        int left = -1, min = Integer.MAX_VALUE;
        int right = -2, max = Integer.MIN_VALUE;
        int n = nums.length;
        for (int i = 0 ; i < n ; i ++) {
            if (max > nums[i]) {
                right = i;
            } else {
                max = nums[i];
            }
            if (min < nums[n - i - 1]) {
                left = n - i - 1;
            } else {
                min = nums[n - i - 1];
            }
        }
        return right - left + 1;
    }
}
```