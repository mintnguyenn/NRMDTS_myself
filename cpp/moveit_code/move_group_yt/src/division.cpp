#include <iostream>
#include <move_group_yt/Node.h>



int main()
{
	int N = 27;
	int color_table[N][4] = {0, 1, 1, 0, 
							 0, 0, 1, 1, 
							 1, 1, 0, 0, 
							 1, 1, 1, 0, 
							 1, 0, 1, 0, 
							 1, 0, 1, 1, 
							 1, 0, 0, 1, 
							 1, 0, 1, 0, 
							 1, 1, 1, 0, 
							 1, 1, 0, 1, 
							 1, 1, 0, 0, 
							 1, 1, 0, 0, 
							 0, 1, 1, 0, 
							 0, 0, 1, 1, 
							 0, 1, 0, 1, 
							 1, 0, 0, 0, 
							 0, 1, 0, 0, 
							 0, 0, 1, 0, 
							 0, 0, 0, 1, 
							 1, 0, 0, 0, 
							 0, 1, 0, 0, 
							 0, 0, 0, 1, 
							 0, 1, 0, 0, 
							 0, 0, 1, 0, 
							 0, 1, 0, 0, 
							 0, 0, 1, 0, 
							 0, 1, 0, 0};

	int A[N][N];
	for(unsigned int i = 0; i < N; i++)
	{
		for(unsigned int j = 0; j < N; j++)
		{
			A[i][j] = 0;
		}
	}

	A[0][3] = 1;
	A[0][16] = 1;
	A[0][17] = 1;
	A[1][5] = 1;
	A[1][17] = 1;
	A[1][18] = 1;
	A[2][3] = 1;
	A[2][15] = 1;
	A[2][16] = 1;
	A[3][4] = 1;
	A[3][7] = 1;
	A[3][8] = 1;
	A[3][12] = 1;
	A[4][5] = 1;
	A[4][17] = 1;
	A[5][6] = 1;
	A[5][8] = 1;
	A[6][9] = 1;
	A[6][18] = 1;
	A[6][19] = 1;
	A[7][15] = 1;
	A[8][9] = 1;
	A[8][13] = 1;
	A[9][10] = 1;
	A[9][14] = 1;
	A[10][19] = 1;
	A[10][20] = 1;
	A[11][15] = 1;
	A[11][26] = 1;
	A[12][26] = 1;
	A[12][25] = 1;
	A[12][24] = 1;
	A[12][23] = 1;
	A[12][22] = 1;
	A[12][13] = 1;
	A[13][14] = 1;
	A[14][21] = 1;
	for(unsigned int i = 0; i < N; i++)
	{
		for(unsigned int j = 0; j < i; j++)
		{
			A[i][j] = A[j][i];
		}
	}
	std::cout << "YT: visualize adjacent matrix: " << std::endl;
	for(unsigned int i = 0; i < N; i++)
	{
		for(unsigned int j = 0; j < N; j++)
		{
			std::cout << A[i][j] << " ";
		}
		std::cout << std::endl;
	}
	std::cout << std::endl;


// Here we should merge the origin date
	// we omit it because we currently use manual data, so the 
	// nodes should be irreducible




	Problem p(N, color_table, A);
	p.solve();


	return 0;
}

