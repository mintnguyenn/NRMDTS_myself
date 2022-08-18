#ifndef _NODE_
#define _NODE_

#include <vector>

class Node
{
public: 

	std::vector<int> v_connect_;

	// true means it cannot judge what index
	// false means that it has already been given an index
	Node(std::vector<int> v_connect)
	{
		open_ = true;

	}

	// copy function



	// 
	void close()
	{
		if(possible_color_.size() >= 2)
		{
			// we cannot judge the color, but we can know whether some possible color mey be pruned
		}

		// maybe after prune color there is only one color left
		if(possible_color_.size() == 1)
		{
			// then we know the color is here
		}
		else if(possible_color_.size() == 0)
		{
			std::cout << "YT: the node has no color to draw, error!" << std::endl;
		}
	}



private:
	std::vector<double> possible_color_;

	// std::vector<int> vertex_;	
	int color_;
	bool open_;
};



#endif