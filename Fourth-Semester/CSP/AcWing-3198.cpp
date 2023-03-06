/*
 * @Description: Coding The World!
 * @Version: 2.0
 * @Author: LostMagician
 * @Date: 2023-02-02 15:38:29
 * @LastEditors: LostMagician
 * @LastEditTime: 2023-03-06 19:20:12
 */
#include <iostream>
#include <cstdio>
#include <cstring>
using namespace std;
struct LinkWindow
{
    int x1;
    int y1;
    int x2;
    int y2;
    int num; // 窗口编号
    LinkWindow *prev;
    LinkWindow *next;
    LinkWindow()
    {
        this->next = NULL;
    }

    bool InBound(int x, int y);
};

LinkWindow *head = NULL;

LinkWindow *CreateWindow(int num, int x1, int y1, int x2, int y2)
{
    LinkWindow *window = (LinkWindow *)malloc(sizeof(LinkWindow));
    window->num = num;
    window->x1 = x1;
    window->y1 = y1;
    window->x2 = x2;
    window->y2 = y2;
    window->prev = NULL;
    window->next = NULL;

    return window;
}

void Initialize(LinkWindow **head)
{
    *head = CreateWindow(0, 0, 0, 0, 0);
}

bool LinkWindow::InBound(int x, int y)
{
    return (x >= this->x1 && y >= this->y1 && x <= this->x2 && y <= this->y2);
}

void Insert(LinkWindow *window)
{
    window->next = head->next;
    if (head->next)
    {
        head->next->prev = window;
    }
    head->next = window;
    window->prev = head;
}

void Delete(LinkWindow *window)
{
    window->prev->next = window->next;
    if (window->next)
    {
        window->next->prev = window->prev;
    }
}

void Click(LinkWindow *window)
{
    if (window->prev != head)
    {
        Delete(window);
        Insert(window);
    }
}

int inBound(int x, int y)
{
    LinkWindow *ptr = head->next;
    int find = 0;
    while (ptr)
    {
        if (ptr->InBound(x, y))
        {
            find = 1;
            Click(ptr);
            return ptr->num;
        }
        ptr = ptr->next; // 漏写这句就寄了
    }

    if (!find)
        return -1;
}

int main()
{
    Initialize(&head);
    int n, m;
    cin >> n >> m;
    LinkWindow *window;
    for (int i = 1; i <= n; i++)
    {
        int x1, y1, x2, y2;
        cin >> x1 >> y1 >> x2 >> y2;
        window = CreateWindow(i, x1, y1, x2, y2);
        Insert(window);
    }
    for (int i = 0; i < m; i++)
    {
        int x, y;
        cin >> x >> y;
        int t = inBound(x, y);
        if (t == -1)
        {
            cout << "IGNORED" << endl;
        }
        else
        {
            cout << t << endl;
        }
    }

    system("pause");
    return 0;
}