#ifndef _PROBLEM_
#define _PROBLEM_

#include <move_group_yt/Node.h>


class Problem
{
public:
	Problem(int N, int* color_table, int* A)
	{
		Node temp;
	}

	// Given an edge, judge which two nodes contain it as bounary
	void locateEdge();

	void mergeNode()
	{

	}

	void showProblem()
	{
		;
	}
	void solve()
	{
		showProblem();
	}
private:
	std::vector<Node> nodes_;
	std::vector<std::pair<double, double> > all_vertex_;
};


#endif