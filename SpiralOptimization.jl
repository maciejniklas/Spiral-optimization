using Distributions

"""
    SpiralOptimization2D(userFunction::Function, searchRegion::Vector=[-100, 100], searchResult::String="MIN", stepType::String="PDDS", amountOfSearchPoints::Int=100, maxIterationNumber::Int=10000, rotationAngle::Float64=pi/3)
"""

function SpiralOptimization2D(userFunction::Function, searchRegion::Vector=[-100, 100], searchResult::String="MIN", stepType::String="PDDS", amountOfSearchPoints::Int=100, maxIterationNumber::Int=10000, rotationAngle::Float64=pi/4)
    try
#------------------------------------------------------------------------------
        #Check conditions
#------------------------------------------------------------------------------
        #Check start requirement about amount of search amountOfSearchPoints
        if(amountOfSearchPoints < 2)
            throw(ArgumentError("Amount of serach points must be greater than 1"))
        end

        #Check start requirement about max iteration number
        if(maxIterationNumber < 2)
            throw(ArgumentError("Max iteration number must be greater than 1"))
        end

        #Check start requirement about search region
        if(searchRegion[1] > searchRegion[2])
            throw(ArgumentError("Search region first value must be lower than seond"))
        end        
        if(length(searchRegion) != 2)
            throw(ArgumentError("Search region length must be equal 2"))
        end

        #Chceck start requirement about serach resulr        
        if(searchResult != "MIN" && searchResult != "MAX")
            throw(ArgumentError("Search result must be equal to 'MIN' or 'MAX'"))
        end

        #Chceck start requirement about step type        
        if(stepType != "PDDS" && stepType != "CS")
            throw(ArgumentError("Step type must be equal to 'PDDS' or 'CS'"))
        end

        #Chceck start requirement about rotation angle        
        if(rotationAngle > pi || rotationAngle < -pi)
            throw(ArgumentError("Rotation angle must be in range of [-pi, pi]"))
        end

#------------------------------------------------------------------------------
        #Initialize
#------------------------------------------------------------------------------
        dimensions = 2

        #Initialize and fill X, Y array
        #   Convention -> [X, X, X, Y, Y, Y]
        pointsX = MyFill(searchRegion, amountOfSearchPoints)
        pointsY = MyFill(searchRegion, amountOfSearchPoints)

        #Initialize and fill Z array
        pointsZ = Float64[]

        for pointIndex in 1:length(pointsY)
            push!(pointsZ, userFunction(pointsX[pointIndex], pointsY[pointIndex]))
        end

        #Initialize iterations value
        iterations = 0

        #Find minimal value and make it current optim container
        #   1 -> X-value, 2 -> Y-value, 3 -> Z-value, 4 -> optim found iteration
        optimData = Float64[1:4;]

        if(searchResult == "MIN")
            optimData[3] = minimum(pointsZ)
        else
            optimData[3] = maximum(pointsZ)
        end

        optimData[4] = iterations
        optimData[1] = pointsX[findall(temp->temp==optimData[3], pointsZ)[1]]
        optimData[2] = pointsY[findall(temp->temp==optimData[3], pointsZ)[1]]

#------------------------------------------------------------------------------
        #Step rate decision and main loop
#------------------------------------------------------------------------------
        stepRate = 0
        center = 0

        #PDDS step rate is constatn value
        if(stepType == "PDDS")
            stepRate = (10^(-3))^(1.0/maxIterationNumber)
        end

        for iterations in 1:maxIterationNumber

            #CS step rate generation
            if(stepType == "CS")
                if(iterations >= optimData[4] + 2*dimensions)
                    stepRate = 0.5^(1/(2*dimensions))
                else
                    stepRate = 1
                end
            end

            #Update center point
            if([optimData[1], optimData[2]] != center)
                center = Float64[optimData[1], optimData[2]]
            end

            #Update search points
            for pointIndex in 1:length(pointsX)
                temp = [pointsX[pointIndex], pointsY[pointIndex]]
                temp = center + stepRate*MyRotate2D(temp - center, rotationAngle)

                pointsX[pointIndex] = temp[1]
                pointsY[pointIndex] = temp[2]
            end

            for pointIndex in 1:length(pointsY)
                pointsZ[pointIndex] = userFunction(pointsX[pointIndex], pointsY[pointIndex])
            end

            #Update optim point
            if(searchResult == "MIN" && optimData[3] > minimum(pointsZ))
                optimData[3] = minimum(pointsZ)
                optimData[4] = iterations
                optimData[1] = pointsX[findall(temp->temp==optimData[3], pointsZ)[1]]
                optimData[2] = pointsY[findall(temp->temp==optimData[3], pointsZ)[1]]
            elseif(searchResult == "MAX" && optimData[3] < maximum(pointsZ))
                optimData[3] = maximum(pointsZ)
                optimData[4] = iterations
                optimData[1] = pointsX[findall(temp->temp==optimData[3], pointsZ)[1]]
                optimData[2] = pointsY[findall(temp->temp==optimData[3], pointsZ)[1]]
            end
        end

        return optimData

    catch exception
        println(exception)
        return
    end
end

"""
MyFill(searchRegion::Vector, amountOfSearchPoints::Int)
"""
#Fill array and return it
function MyFill(searchRegion::Vector, amountOfSearchPoints::Int)
    points = Float64[]
    pointIndex = 1
        temp = 0

        while(pointIndex != amountOfSearchPoints + 1)
            #Generate a value
            temp = rand(Uniform(searchRegion[1], searchRegion[2]))

            #Check if generated value is in points array
            if(temp in points)
                pointIndex -= 1
            else
                push!(points, temp)
                temp = 0
            end

            pointIndex += 1
        end
    
    return points
end

"""
MyRotate2D(values::Vector, angle::Float64)
"""
#Rotate values with given angle
function MyRotate2D(values::Vector, angle::Float64)
    return [values[1]*cos(angle) - values[2]*sin(angle), values[1]*sin(angle)+values[2]*cos(angle)]
end