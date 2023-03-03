/*
 * @Author: LostMagician 2875929124@qq.com
 * @Date: 2023-02-27 19:50:54
 * @LastEditors: LostMagician
 * @LastEditTime: 2023-03-03 22:08:19
 * @FilePath: \C++ Code\Lab1.cpp
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
 */
#include <iostream>
#include <cstdio>
#include <cstring>
#include <cmath>
#include <fstream>
#include <ctime>

using namespace std;

int count = 0;

const int N = 2050;
class Matrix
{
public:
    double **data;
    int length;
    int width;
    Matrix()
    {
        length = 0;
        width = 0;
        data = (double **)malloc(sizeof(double *) * length); // sizeof(int*),不能少*，一个指针的内存大小，每个元素是一个指针。
        for (int i = 0; i < length; i++)
        {
            data[i] = (double *)malloc(sizeof(double) * width);
        }
    }

    Matrix(int l, int w)
    {
        length = l;
        width = w;
        data = (double **)malloc(sizeof(double *) * length); // sizeof(int*),不能少*，一个指针的内存大小，每个元素是一个指针。
        for (int i = 0; i < length; i++)
        {
            data[i] = (double *)malloc(sizeof(double) * width);
        }
    }

    Matrix(int l_1, int l_2, int w_1, int w_2, Matrix &m) // 左闭右开
    {
        length = l_2 - l_1;
        width = w_2 - w_1;
        data = (double **)malloc(sizeof(double *) * length); // sizeof(int*),不能少*，一个指针的内存大小，每个元素是一个指针。
        for (int i = 0; i < length; i++)
        {
            data[i] = (double *)malloc(sizeof(double) * width);
        }
        for (int i = l_1, k1 = 0; i < l_2; i++, k1++)
        {
            for (int j = w_1, k2 = 0; j < w_2; j++, k2++)
            {
                data[k1][k2] = m.data[i][j];
            }
        }
    }
};

void printMatrix(Matrix &m)
{
    for (int i = 0; i < m.length; i++)
    {
        for (int j = 0; j < m.width; j++)
        {
            cout << m.data[i][j] << ' ';
        }
        cout << endl;
    }
}

Matrix operator+(const Matrix &a, const Matrix &b)
{
    int length = a.length;
    int width = b.length;
    Matrix matrix(length, width);
    for (int i = 0; i < length; i++)
    {
        for (int j = 0; j < width; j++)
        {
            matrix.data[i][j] = a.data[i][j] + b.data[i][j];
        }
    }

    matrix.length = length;
    matrix.width = width;
    return matrix;
}

Matrix operator-(const Matrix &a, const Matrix &b)
{

    int length = a.length;
    int width = b.length;
    Matrix matrix(length, width);
    for (int i = 0; i < length; i++)
    {
        for (int j = 0; j < width; j++)
        {
            matrix.data[i][j] = a.data[i][j] - b.data[i][j];
        }
    }

    return matrix;
}

Matrix operator*(const Matrix &a, const Matrix &b)
{
    int size = a.length;
    Matrix matrix(size, size);
    for (int i = 0; i < size; i++)
    {
        for (int j = 0; j < size; j++)
        {
            double sum = 0;
            for (int k = 0; k < size; k++)
            {
                sum += a.data[i][k] * b.data[k][j];
            }
            matrix.data[i][j] = sum;
        }
    }

    return matrix;
}

Matrix mult(Matrix &a, Matrix &b)
{
    if (a.length <= 128)
    {
        Matrix new_m;

        new_m.length = a.length;
        new_m.width = a.length;
        new_m = a * b;

        return new_m;
    }
    int l = a.length;
    int h_l = a.length / 2;
    Matrix a1(0, h_l, 0, h_l, a);
    Matrix a2(0, h_l, h_l, l, a);
    Matrix a3(h_l, l, 0, h_l, a);
    Matrix a4(h_l, l, h_l, l, a);
    Matrix b1(0, h_l, 0, h_l, b);
    Matrix b2(0, h_l, h_l, l, b);
    Matrix b3(h_l, l, 0, h_l, b);
    Matrix b4(h_l, l, h_l, l, b);

    Matrix s1 = b2 - b4;
    Matrix s2 = a1 + a2;
    ;
    Matrix s3 = a3 + a4;
    Matrix s4 = b3 - b1;
    Matrix s5 = a1 + a4;
    Matrix s6 = b1 + b4;
    Matrix s7 = a2 - a4;
    Matrix s8 = b3 + b4;
    Matrix s9 = a1 - a3;
    Matrix s10 = b1 + b2;

    Matrix p1 = mult(a1, s1);
    Matrix p2 = mult(s2, b4);
    Matrix p3 = mult(s3, b1);
    Matrix p4 = mult(a4, s4);
    Matrix p5 = mult(s5, s6);
    Matrix p6 = mult(s7, s8);
    Matrix p7 = mult(s9, s10);
    Matrix c1 = p5 + p4 - p2 + p6;
    Matrix c2 = p1 + p2;
    Matrix c3 = p3 + p4;
    Matrix c4 = p5 + p1 - p3 - p7;

    Matrix res(l, l);

    for (int i = 0; i < h_l; i++)
    {
        for (int j = 0; j < h_l; j++)
        {
            res.data[i][j] = c1.data[i][j];
            res.data[i][j + h_l] = c2.data[i][j];
            res.data[i + h_l][j] = c3.data[i][j];
            res.data[i + h_l][j + h_l] = c4.data[i][j];
        }
    }

    return res;
}

int to_2_exp(int x)
{
    for (int i = 0; i < 15; i++)
    {
        if ((1 << i) >= x)
            return (1 << i);
    }
    return 0;
}

Matrix a(1024, 1024), b(1024, 1024);

int main()
{
    ifstream infile;
    infile.open("data3.txt");

    for (int i = 0; i < 1000; i++)
    {
        for (int j = 0; j < 1000; j++)
        {
            infile >> a.data[i][j];
        }
    }
    infile.close();

    infile.open("data4.txt");

    for (int i = 0; i < 1000; i++)
    {
        for (int j = 0; j < 1000; j++)
        {
            infile >> b.data[i][j];
        }
    }
    infile.close();

    clock_t begin, end;

    begin = clock();

    Matrix result = mult(a, b);

    end = clock();

    ofstream outfile;

    fstream f;
    f.open("Strassen_RunTime.txt", ios::out | ios::app);

    double runTime = (double)(end - begin) / CLOCKS_PER_SEC * 1000;
    f << runTime << endl;
    f.close();

    return 0;
}
