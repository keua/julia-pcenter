using JuMP
using Cbc
using NamedArrays

function readf(fname::AbstractString)
    # this is the file structure we're trying to read
    # n p
    # d11 d12 ... d1n
    # d21 d22 ... d2n
    # .   . .     .
    # .   .   .   .
    # .   .     . .
    # dn1 dn2 ... dnn

    f = open(fname)
    line1 = split(readline(f),'\t')
    try
        n = parse(Int,line1[1])
        p = parse(Int,line1[2])
    catch
        f = open(fname)
        line1 = split(readline(f),' ')
    end
    n = parse(Int,line1[1])
    p = parse(Int,line1[2])

    dist = readdlm(f, '\t') # reading matrix

    dist = convert(Matrix{Int}, dist[1:n,1:n]) # cleaning matrix

    return n, p, dist
end

function classicdaskinpcenter(selsolver, n, p, dist)

    m = Model(solver = selsolver)

    # Declaring variables
    @variable(m, y[ j=1:n ], category = :Bin)
    @variable(m, x[ i=1:n , j=1:n ], category = :Bin)
    @variable(m, z)

    # Declaring the objective
    @objective(m, Min, z)

    # Declaring the constraints (The order could change the results)
    @constraint(m, [ i=1:n ], sum( dist[i,j] * x[i,j] for j=1:n ) <= z)
    @constraint(m, [ i=1:n ] , sum( x[i,j] for j=1:n ) == 1 )
    @constraint(m, [ i=1:n, j=1:n ], x[i,j] <= y[j] )
    @constraint(m, sum( y[j] for j=1:n ) <= p )

    return m,x,y,z

end

function elloumipcenter(selsolver, n, p, dist)

    m = Model(solver = selsolver)

    # D = sort(unique(nonzeros(sparse(dist)))) # This can change the results
    D = sort(unique(dist))
    k = length(D)

    println("\nD = ",D)
    println("k = ",k)

    # Declaring variables
    @variable(m, y[ j=1:n ] , category = :Bin)
    @variable(m, uk[ ik=2:k ], category = :Bin)

    # Declaring the objective
    @objective(m, Min, D[1]  + sum( (D[ki]-D[ki-1]) * uk[ki] for ki = 2:k ))

    # Declaring the constraints (The order could change the results)
    @constraint(m, sum( y[j] for j=1:n ) >= 1 )
    @constraint(m, sum( y[j] for j=1:n ) <= p )
    @constraint(
        m,
        [ i=1:n, ik=2:k ],
        uk[ik] + sum( y[j] for j=1:n if dist[i,j] < D[ik]) >= 1
    )

    return m,y,uk

end

function main()
    file = "Instances/test.dat"
    method = "Elloumi"
    loglev = 0
    timeout = 7200.00
    ratio = 0
    threads = 1

    for i=1:length(ARGS)
        arg = ARGS[i]
        val = split(arg,"=")[2]
        if contains(arg,"-f")
            file = val
        elseif contains(arg,"-m")
            method = val
        elseif contains(arg,"-l")
            loglev = parse(Int,val)
        elseif contains(arg,"-r")
            ratio = parse(Float64,val)
        elseif contains(arg,"-t")
            timeout = parse(Float64,val)
        elseif contains(arg,"-th")
            threads = parse(Int,val)
        end
    end

    solvepcenter(file,method,loglev,ratio,timeout,threads)

end

function solvepcenter(instancef, method, loglev, ratio, timeout, thrds)

    # Setting the data

    n, p, dist = readf(instancef)
    method = uppercase(method)
    println("\n###############################################################")
    println(" General Information ")
    println("###############################################################\n")
    println("Formulation: $method, loglevel: $loglev , ratio: $ratio, ")
    println("timeout: $timeout, threads: $thrds \n")
    println("Problem parameters: \n n = $n \n p = $p \n")
    println("Instance values: \n",NamedArray(dist))

    # Proceeding to the optimization

    selsolver = CbcSolver(
        logLevel=loglev,
        ratioGap=ratio,
        seconds=timeout,
        threads=thrds
    )

    if "DASKIN" == uppercase(method)
        dm, dx, dy, dz = classicdaskinpcenter(selsolver, n, p, dist)
        # Displaying the results Daskin
        status = solve(dm)

        if status == :Optimal || status == :UserLimit
            println("\n###############################################################")
            println(" Daskin ")
            println("###############################################################\n")
            println("X \n", NamedArray(getvalue(dx)))
            println("\nY \n",NamedArray(getvalue(dy)))

            selnodes = "Selected nodes: "

            for j=1:n
                if getvalue(dy[j]) == 1
                    selnodes = string(selnodes, j, ", ")
                end
            end
            selnodes = chop(chop(selnodes)) # removing ", " from the last iteration
            
            println("\nOptimal !");
            println("Objective function value is ", getobjectivevalue(dm))
            println(selnodes, "\n")

        end
    elseif "ELLOUMI" == uppercase(method)
        em, ey, euk = elloumipcenter(selsolver, n, p, dist)
        # Displaying the results Elloumi
        status = solve(em)

        if status == :Optimal || status == :UserLimit
            println("\n###############################################################")
            println(" Elloumi ")
            println("###############################################################\n")
            println("Y \n",NamedArray(getvalue(ey)))
            println("\n",getvalue(euk))

            selnodes = "Selected nodes: "

            for j=1:n
                if getvalue(ey[j]) == 1
                    selnodes = string(selnodes, j, ", ")
                end
            end
            selnodes = chop(chop(selnodes)) # removing ", " from the last iteration

            println("\nOptimal !");
            println("Objective function value is ", getobjectivevalue(em))
            println(selnodes)    

        end
    end
end

# Main function
main()