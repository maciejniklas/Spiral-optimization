"""
(searchPointsNumber::Int, maxIterationNumber::Int,
    xSearchRegion::Vector, ySearchRegion::Vector)

Search for extrama
"""
function SpiralOptimization(userFunction::Function, dimensions::Int, 
        searchPointsNumber::Int, maxIterationNumber::Int, searchRegions::Array,
        extremaType::String)
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
        if(length(searchRegions) != dimensions-1)
            throw(ArgumentError("Amount of search regions must be equal to dimensions number"))
        end

        #Check that each of search regions have 2 elements
        for index in 1:dimensions-1;
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
        point = Vector(1.0:Number(dimensions-1))        
        pointNumber = 1
        
        while(pointNumber != searchPointsNumber+1)
            
            #Generate single point
            for pointIndex in 1:dimensions-1;
               point[pointIndex] = rand(Uniform(searchRegions[pointIndex][1], searchRegions[pointIndex][2]))
            end
            
            #Check if searchPoints contain genereted point
            if(point in searchPoints)
                pointNumber -= 1
            else            
                searchPoints[pointNumber] = Vector(point)
            end
            
            pointNumber += 1
        end
        
        #Compute start optim point
        optimArg = 0
        optimVal = 0
        
        if(extremaType == "Max")
            optimVal = -1.7976931348623157e+308
        
            for index in 1:searchPointsNumber;
                if(userFunction(searchPoints[index]) > optimVal)
                    optimVal = userFunction(searchPoints[index])
                    optimArg = searchPoints[index]
                end
            end                
        elseif(extremaType == "Min")
            optimVal = 1.7976931348623157e+308
        
            for index in 1:searchPointsNumber;
                if(userFunction(searchPoints[index]) < optimVal)
                    optimVal = userFunction(searchPoints[index])
                    optimArg = searchPoints[index]
                end
            end         
        end
        
        return println("Arg: ", optimArg, "\tVal: ", optimVal, "\n", searchPoints)
#------------------------------------------------------------------------------
    catch exception
        println(exception)
        return
    end
end