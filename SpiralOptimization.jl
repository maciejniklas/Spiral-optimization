"""
(searchPointsNumber::Int, maxIterationNumber::Int,
    xSearchRegion::Vector, ySearchRegion::Vector)

Search for extrama
"""
function SpiralOptimization(userFunction::Function, dimensions::Int, 
        searchPointsNumber::Int,maxIterationNumber::Int, searchRegions::Array)
    try
#------------------------------------------------------------------------------
        """
        Check start requirement about dimension
        """
        if(dimensions < 2)
            throw(ArgumentError("Dimension must be greater than 1"))
        end
        """
        Check start requirement about amount of search points
        """
        if(searchPointsNumber < 2)
            throw(ArgumentError("Amount of search points must be greater than 1"))
        end
        """
        Check start requirement about max iteration number
        """
        if(searchPointsNumber < 2)
            throw(ArgumentError("Max iteration number must be greater than 1"))
        end
        """
        Check start requirement about amount of search regions
        """
        if(length(searchRegions) != dimensions)
            throw(ArgumentError("Amount of search regions must be equal to dimensions number"))
        end
#------------------------------------------------------------------------------
        # Initialize search points and determine the center 
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
    catch exception
        println(exception)
        return
    end
end