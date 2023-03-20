/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package heapsort;

/**
 *
 * @author Lena
 */
public class HeapSorter {
        
    private int[] a;

    public HeapSorter(int[] anArray) {
        a = anArray;
    }
    
    public void sort() {  
        int n = a.length - 1;
        for (int i = (n - 1) / 2; i >= 0; i--)
            fixHeap(i, n);
        while (n > 0) {
            swap(0, n);
            n--;
            fixHeap(0, n);
        }
    }

    private void fixHeap(int rootIndex, int lastIndex) {
        // Remove root
        int rootValue = a[rootIndex];

        // Promote children while they are larger than the root      
        int index = rootIndex;
        boolean more = true;
        while (more) {
            int childIndex = getLeftChildIndex(index); //2 * index + 1
            if (childIndex <= lastIndex) {
                // Use right child instead if it is larger
                int rightChildIndex = getRightChildIndex(index);//2 * index + 2
                if (rightChildIndex <= lastIndex && a[rightChildIndex] > a[childIndex]) {
                    childIndex = rightChildIndex;
                }

                if (a[childIndex] > rootValue) {
                    // Promote child
                    a[index] = a[childIndex];
                    index = childIndex;
                } else {
                    // Root value is larger than both children
                    more = false;
                }
            } else {
                // No children
                more = false; 
            }
        }
    
        // Store root value in vacant slot
        a[index] = rootValue;
    }

    private void swap(int i, int j) {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }

    private static int getLeftChildIndex(int index) {
        return 2 * index + 1;
    }

    private static int getRightChildIndex(int index) {
        return 2 * index + 2;
    }
}
