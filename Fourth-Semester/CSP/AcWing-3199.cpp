/*
 * @Description: Coding The World!
 * @Version: 2.0
 * @Author: LostMagician
 * @Date: 2023-03-06 20:11:55
 * @LastEditors: LostMagician
 * @LastEditTime: 2023-03-06 23:16:43
 */
#include <iostream>
#include <string>
#include <cstring>
#include <vector>
#include <algorithm>
#include <map>
#include <sstream>
const int N = 300;

using namespace std;
string command;

struct Param
{
    char c;
    string par;
};

string par[30];

int Exist(vector<Param> &s, char c)
{
    int l = s.size();
    for (int i = 0; i < l; i++)
    {
        if (c == s[i].c)
            return i;
    }
    return -1;
}

int main()
{
    map<char, int> params;

    string collection;
    cin >> collection;

    int len = collection.size();
    for (int i = 0; i < len; i++)
    {
        if (collection[i] != ':')
        {
            if (i + 1 < len)
            {
                if (collection[i + 1] == ':')
                {
                    params.insert(make_pair(collection[i], 1));
                }
                else
                {
                    params.insert(make_pair(collection[i], 0));
                }
            }
            else
            {
                params.insert(make_pair(collection[i], 0));
            }
        }
    }

    int n;
    cin >> n;
    char u = getchar();

    for (int i = 1; i <= n; i++)
    {
        // getline(cin, command);
        cout << "Case " << i << ":";
        getline(cin, command);

        stringstream option(command);
        vector<string> ops;
        while (option >> command)
            ops.push_back(command);

        int t = ops.size();

        for (int i = 0; i < 26; i++)
        {
            par[i].clear();
        }

        for (int i = 1; i < t; i++)
        {
            if (ops[i][0] != '-' || ops[i][1] < 'a' || ops[i][1] > 'z' || ops[i].size() != 2 || params.count(ops[i][1]) != 1)
                break;

            if (params[ops[i][1]] == 0)
                par[ops[i][1] - 'a'] = "X";
            else
            {
                if (i + 1 < t)
                {
                    par[ops[i][1] - 'a'] = ops[i + 1];
                    i++;
                }
                else
                    break;
            }
        }

        for (int i = 0; i < 26; i++)
        {
            if (!par[i].empty())
            {
                cout << " " << '-' << (char)('a' + i);
                if (par[i] != "X")
                {
                    cout << " " << par[i];
                }
            }
        }

        cout << endl;
    }
}