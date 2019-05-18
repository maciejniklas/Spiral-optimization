"""
(searchPointsNumber::Int, maxIterationNumber::Int,
    xSearchRegion::Vector, ySearchRegion::Vector)

Search for extrama
"""
function SpiralOptimization(userFunction::Function, dimensions::Int, 
        searchPointsNumber::Int,maxIterationNumber::Int, searchRegions::Array)
    try
#------------------------------------------------------------------------------
        #Check start requirement about dimension
        if(dimensions < 2)
            throw(ArgumentError("Dimension must be greater than 1"))
        end
        
        #Check start requirement about amount of search points
        if(searchPointsNumber < 2)
            throw(ArgumentError("Amount of search points must be greater than 1"))
        end
        
        #Check start requirement about max iteration number
        if(searchPointsNumber < 2)
            throw(ArgumentError("Max iteration number must be greater than 1"))
        end
        
        #Check start requirement about amount of search regions
        if(length(searchRegions) != dimensions)
            throw(ArgumentError("Amount of search regions must be equal to dimensions number"))
        end

        #Check that each of search regions have 2 elements
        for index in 1:dimensions;
            if(length(searchRegions[index]) != 2)
                throw(ArgumentError("Search region must have exact 2 elements"))
            end
        end
#------------------------------------------------------------------------------
        # Initialize search points and determine the center 
#------------------------------------------------------------------------------
        
        #Create array that will hold our generated search points
        searchPoints = Any[1:searchPointsNumber;]
        
        #Loop for generate search points
        point = Vector(1.0:Number(dimensions))
        
        for pointNumber in 1:searchPoints;
            
            #Generate single point
            for pointIndex in 1:dimensions;
               point[pointIndex] = rand(Uniform(searchRegions[dimensions][1],searchRegions[dimensions][2]))
            end
            
            searchPoints[pointNumber] = point
        end
#------------------------------------------------------------------------------
    catch exception
        println(exception)
        return
    end
end