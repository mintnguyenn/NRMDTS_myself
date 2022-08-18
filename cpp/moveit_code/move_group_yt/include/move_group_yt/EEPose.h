#ifndef _EEPOSE_
#define _EEPOSE_

class EEPose{
public:
    EEPose(int num_of_solution, double* angle)
    {
        // that means we have solved the IK
        // angle must be 8*6 array
        std::cout << "YT: create EEPose with " << num_of_solution << "solutions" << std::endl;

        for(unsigned int i = 0; i < 8; i++)
        {
            Joint[i] = new double[6];
        }

        unsigned int i;
        for(i = 0; i < 8; i++)
        {
            // first we check the validity of the joint
            if (angle[i*8] < 0 || angle[i*8] > 2*M_PI || 
                angle[i*8+1] < 0 || angle[i*8+1] > 2*M_PI || 
                angle[i*8+2] < 0 || angle[i*8+2] > 2*M_PI || 
                angle[i*8+3] < 0 || angle[i*8+3] > 2*M_PI || 
                angle[i*8+4] < 0 || angle[i*8+4] > 2*M_PI || 
                angle[i*8+5] < 0 || angle[i*8+5] > 2*M_PI  
                )
            {
                break;
            }

            for(unsigned int j = 0; j < 6; j++)
            {
                Joint[i][j] = angle[i*8+j];
            }
        }
        num_of_solution_ = i;
        std::cout << "YT: actually " << i << "solution(s) valid" << std::endl;
    }
    ~EEPose()
    {
        for(unsigned int i = 0; i < 6; i++)
        {
            delete[] Joint[i];
        }
    }
    void print()
    {
        std::cout << "EEPose: num_of_solution_: " << num_of_solution_ << std::endl;
        for(unsigned int i = 0; i < 8; i++)
        {
            std::cout << "(";
            for(unsigned int j = 0; j < 5; j++)
            {
                std::cout << Joint[i][j] << ", ";
            }
            std::cout << Joint[i][5] << ")" << std::endl;
        }
    }
    std::vector<double> getJoint(int i)
    {
        std::vector<double> result;
        result.clear();
        for(unsigned int j = 0; j < 6; j++)
        {
            result.push_back(Joint[i][j]);
        }
        return result;
    }
private:
    int num_of_solution_;
    double *Joint[8];
};






#endif