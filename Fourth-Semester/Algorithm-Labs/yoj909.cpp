/*
 * @Description: Coding The World!
 * @Version: 2.0
 * @Author: LostMagician
 * @Date: 2023-03-06 14:27:36
 * @LastEditors: LostMagician
 * @LastEditTime: 2023-03-06 15:44:25
 */
#include <iostream>
#include <cstring>
#include <algorithm>
#include <vector>
#include <cstdio>
using namespace std;

class QuickSelect
{
public:
    vector<int> data;
    QuickSelect(int n)
    {
        data.resize(n);
    };
    QuickSelect(vector<int> v);
    void pirntData(vector<int> &v);
    void k_select(int k);
};

QuickSelect::QuickSelect(vector<int> v)
{
    data.resize(v.size());
    copy(v.begin(), v.end(), data.begin());
}

void QuickSelect::k_select(int k)
{
    for (int low = 0, high = data.size() - 1; low < high;)
    {
        int i = low, j = high;
        int pivot = data[low];
        while (i < j)
        {
            while (i < j && pivot <= data[j])
                j--;
            data[i] = data[j];
            while (i < j && data[i] <= pivot)
                i++;
            data[j] = data[i];
        }

        data[i] = pivot;
        if (k <= i)
            high = i - 1;
        if (i <= k)
            low = i + 1;
    }
}

int main()
{
    int n, k;
    cin >> n >> k;
    QuickSelect task(n);

    for (int i = 0; i < n; i++)
    {
        scanf("%d", &task.data[i]);
    }

    task.k_select(k - 1);
    cout << task.data[k - 1] << endl;
    // system("pause");
    return 0;
}