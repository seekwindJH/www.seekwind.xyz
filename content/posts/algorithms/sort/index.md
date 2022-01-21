---
title: "Sort"
date: 2022-01-21T11:01:40+08:00
draft: false
---

经典的排序算法：归并排序、快速排序、堆排序。

<!--more-->

而在解决算法问题时，我们大部分的思路都围绕其展开，偶尔会用到其他思路。其中最典型的一类题就是K个最大值问题。

## 1. 堆排序思路

这道题来自于[LeetCode23.合并K个升序链表](https://leetcode-cn.com/problems/merge-k-sorted-lists/)。给定K个升序链表，将其合并成一个升序链表。

这道题其实有以下几种思路：
1. 两两归并链表，最终归并成一个链表。
2. 将所有链表的所有节点追加到堆中，逐一提取。
3. 每次将K个链表的首节点加入到堆中，提取一个，加入一个。

方案1简单粗暴，方案2没有用到升序链表的条件，方案3则是利用了升序条件的方案2升级版，使得堆的深度可控。

```java
class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        // 建立最小堆
        PriorityQueue<ListNode> heap = new PriorityQueue<>(Comparator.comparingInt(node -> node.val));
        // 把每个链表的第一个节点放到heap中
        for (ListNode node : lists) {
            // 测试用例有点坑爹，有的ListNode是null
            if(node != null) {
                heap.offer(node);
            }
        }
        ListNode ans = new ListNode();
        ListNode cur = ans;
        while(!heap.isEmpty()) {
            // 打擂台，heap中最小的节点被打下来
            cur.next = heap.poll();
            cur = cur.next;
            // 然后把它的下一个节点放进heap中，继续打擂台
            if (cur.next != null) {
                heap.offer(cur.next);
            }
        }
        return ans.next;
    }
}
```

## 2. 快速排序思路

还有一类题是使用快速排序思路的。这道题来自于[LeetCode15.数组中第K个最大元素](https://leetcode-cn.com/problems/kth-largest-element-in-an-array/)。给定一个数组，返回第K大元素。

熟悉快速排序的人一定记得，在快速排序中，有个辅助函数叫做partition。partition的作用是：将数组分为两个部分，
* 左半部分的所有元素均小于枢轴元素
* 右半部分的所有元素均大于枢轴元素

因此，我们可以计算出枢轴元素在数组中的排名：
* 如果**排名比K大**，则第K大元素出现在数组的**右半部分**，我们再对右半部分做partition操作
* 如果**排名比K小**，则第K大元素出现在数组的**左半部分**，我们再对左半部分做partition操作

反复以上操作，终有一日，枢轴元素的排名就是K，那么此时，枢轴元素也就是我们所需要返回的元素。

```java
class Solution {
    public int findKthLargest(int[] nums, int k) {
        int left = 0;
        int right = nums.length - 1;
        int index = -1;
        while (nums.length - k != index) {
            index = partition(nums, left, right);
            if (nums.length - k > index) {
                // 在右半侧
                left = index + 1;
            } else if (nums.length - k < index) {
                // 在左半侧
                right = index - 1;
            }
        }
        return nums[index];
    }
    // 彻彻底底的QuickSort的partition操作
    private int partition(int[] nums, int left, int right) {
        // 枢轴元素
        int pivot = nums[left];
        // 观察这种方式的partition循环
        // 特别巧妙便捷
        while (left < right) {
            while (left < right && nums[right] > pivot) {
                right --;
            }
            nums[left] = nums[right];
            while (left < right && nums[left] <= pivot) {
                left ++;
            }
            nums[right] = nums[left];
        }
        nums[left] = pivot;
        return left;
    }
}
```

下面来看一道升级版的题目。这道题来自于[LeetCode347.前K个高频元素](https://leetcode-cn.com/problems/top-k-frequent-elements/)。给定一个int数组，数组中有重复元素。请返回数组中出现频率前K高的所有元素。

看上去，好像还挺麻烦的。但仔细一想，却发现很简单。“出现频率前K高”，所以我们要先求出所有数字出现的频率。这个用一个HashMap就可以解决，十分简单。

既然要找到前K个高频元素，那我们何不使用QuickSort的partition操作，直接找枢轴元素是第K个元素的情况。所以接下来的步骤和上一题几乎一致，我们只要找枢轴元素是第K个元素的情况。


```java
class Solution {
    public int[] topKFrequent(int[] nums, int k) {
        // 统计出现频率
        Map<Integer, Integer> valCountMap = new HashMap<>();
        for (int num : nums) {
            valCountMap.put(num, valCountMap.getOrDefault(num, 0) + 1);
        }
        // 将出现频率转存在数组中，方便按频率partition
        int[][] valCountArr = new int[valCountMap.size()][2];
        int index = 0;
        for (Map.Entry<Integer, Integer> entry : valCountMap.entrySet()) {
            valCountArr[index][0] = entry.getKey();
            valCountArr[index][1] = entry.getValue();
            index ++;
        }

        int left = 0;
        int right = valCountArr.length - 1;
        int pivotIndex = -1;
        while (pivotIndex != k - 1) {
            pivotIndex = partition(valCountArr, left, right);
            if (pivotIndex < k - 1) {
                // 第K大频率的元素在右边
                left = pivotIndex + 1;
            } else if (pivotIndex > k - 1) {
                // 第K大频率的元素在左边
                right = pivotIndex - 1;
            }
        }
        // 将结果复制到数组中
        int[] res = new int[k];
        for (int i = 0 ; i < k ; i ++) {
            res[i] = valCountArr[i][0];
        }
        return res;
    }
    // 依旧是QuickSort的partition
    // 不同点在于是按照arr的第二列排序，而且是降序排序
    private int partition(int[][] arr, int left, int right) {
        int[] pivot = new int[] {arr[left][0], arr[left][1]};
        while (left < right) {
            while (left < right && arr[right][1] < pivot[1]) {
                right --;
            }
            arr[left] = arr[right];
            while (left < right && arr[left][1] >= pivot[1]) {
                left ++;
            }
            arr[right] = arr[left];
        }
        arr[left] = pivot;
        return left;
    }
}
```

这两题看下来，你会发现：哦~原来快速排序思路的算法不过如此🐼。

## 3. 其他一些排序题

当然，除了那几种经典的排序，下面再介绍个好玩的题。

这道题来自于[LeetCode406.根据身高重建队列](https://leetcode-cn.com/problems/queue-reconstruction-by-height/)。给定一个n*2的二维数组`people`:
* `people[i][0]`代表第i个人的身高
* `people[i][1]`代表第i个人的前方有多少人身高比他高，或者和它一样高

根据这个二维数组，我们要给这几个人重新排序，使得排序完成后的数组满足`people[i][1]`的条件。

初看此题，没有思路是很正常的，这也正是本题好玩的地方。我们不妨这么思考：既然`people[i][0]`代表前方身高大于等于`people[i][0]`的人数，那么在决定这个人的位置之前，最好比他高的人都已经排队了。由此可知，我们可以先将`people`数组按照身高降序排列，然后从高到低决定他们的排队位置。也就是说，高个子已经在之前插入了，**那么后续矮个子的位置不会影响`people[i][1]`的值**。

此题还有个细节：将身高从高到低排序时，我们遇到身高相等的两个人时，应该按照其`people[i][1]`的值升序，来保证后面插入的人的`people[i][1]`值能够更大。

```java
class Solution {
    public int[][] reconstructQueue(int[][] people) {
        Arrays.sort(people, (p1, p2) -> {
            if (p1[0] != p2[0]) {
                // 按身高降序
                return p2[0] - p1[0];
            }else {
                // 身高一样，按第二个字段升序
                return p1[1] - p2[1];
            }
        });
        List<int[]> res = new LinkedList<>();
        for (int[] p : people) {
            // 从高到低插入合理位置
            res.add(p[1], p);
        }
        return res.toArray(new int[people.length][2]);
    }
}
```

## 4. 总结

排序算法，看似简答，实则很有意思。