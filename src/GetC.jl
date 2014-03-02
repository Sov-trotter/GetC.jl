# Jasper den Ouden 02-08-2012
# Robert J Ennis   03-13-2013
# Placed in the public domain

module GetC

export @getCFun

const __ofTypeSym = symbol("::")

macro getCFun(lib, jlFun, cFun)
    cName = cFun.args[1].args[1]

    arguments = map(function (arg)
                        if isa(arg, Symbol)
                            arg = Expr(__ofTypeSym, arg)
                        end
                        return arg
                    end, cFun.args[1].args[2:end])

    # Get info out of arguments of `cFun`
    argumentNames = map(arg->arg.args[1], arguments)
    returnType    = cFun.args[2]
    inputTypes    = map(arg->arg.args[2], arguments)

    # Construct the result.
    cSym       = Expr(:quote,cName)
    symAndLib = :($cSym, $lib)

    body = Expr(:ccall, symAndLib, returnType, Expr(:tuple,inputTypes...), argumentNames...)
    ret  = Expr(:function, Expr(:call, jlFun, argumentNames...), body)
    return esc(ret)

end

end #module GetC
