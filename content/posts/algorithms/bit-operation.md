---
title: "Bit Operation"
date: 2021-12-25T10:19:42+08:00
draft: false
categories:
    - algorithms
---

位操作是计算机能够直接执行的底层操作，效率更高，在某些场合能够发生奇效。

<!--more-->

常见的位运算有：
* 与 `&`
* 或 `|`
* 非 `!`
* 异或 `^`

而其中最最关键的，往往是异或。

## 1. 显著的位运算算法

这道题来自于[LeetCode461汉明距离](https://leetcode-cn.com/problems/hamming-distance/)。两个整数的汉明距离，即两个数字的二进制位之间不同的位数。

注意到异或运算，只有当两个二进制位不同时，才会得到1。因此，使用异或运算可以实现目的。

使用异或运算，我们也有两种途径：
1. 从低位到高位逐位比较。
    ```java
    class Solution {
        public int hammingDistance(int x, int y) {
            int res = 0;
            while (x > 0 || y > 0) {
                // 每次比较最低位
                res += (x & 1) ^ (y & 1);
                x >>= 1;
                y >>= 1;
            }
            return res;
        }
    }
    ```
2. 直接对两个数字的异或结果做统计，因为对int的异或操作是按位异或。
    ```java
    class Solution {
        public int hammingDistance(int x, int y) {
            int xor = x ^ y;
            int res = 0;
            while (xor > 0) {
                res += (xor & 1);
                xor >>= 1;
            }
            return res;
        }
    }
    ```

## 2. 不显著的位运算算法

这道题来自于[LeetCode136只出现一次的数字](https://leetcode-cn.com/problems/single-number/)。给定一个非空的int数组，除了一个元素只出现一次外，其他所有元素都出现了两次。如何找出那个只出现一次的元素呢？

我们知道，异或运算两个相同的数字时，会得到0。实际上，只要是偶数个相同的元素参与计算，都会得到0。那么我们岂不是只要将所有的元素都参与异或运算，出现两次的数字两两相消，最后只会留下那个出现了一次的数字。


```java
class Solution {
    public int singleNumber(int[] nums) {
        int res = 0;
        for (int num : nums) {
            res ^= num;
        }
        return res;
    }
}
```