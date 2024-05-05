# Chapter 2 Linear List

## 2.3 其他操作

=== "反转链表"

    ```C
    ListNode *reverse(ListNode *head) {
        ListNode *newHead = NULL;
        ListNode *tmp, *cur = head;
        while (head != NULL) {
            tmp = head->next;
            head->next = newHead;
            newHead = head;
            head = tmp;
        }
        return newHead;
    }
    ```