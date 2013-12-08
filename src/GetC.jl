# Jasper den Ouden 02-08-2012
# Robert J Ennis   03-13-2013
# Placed in the public domain

module GetC

export @get_c_fun

const _of_type_sym = symbol("::")

macro get_c_fun(lib, jlfun, cfun)
    c_name = cfun.args[1].args[1]

    arguments = map(function (arg)
                        if isa(arg, Symbol)
                            arg = Expr(_of_type_sym, arg)
                        end
                        return arg
                    end, cfun.args[1].args[2:])

    # Get info out of arguments of `from_fun`
    argument_names = map(arg->arg.args[1], arguments)
    return_type    = cfun.args[2]
    input_types    = map(arg->arg.args[2], arguments)

    # Construct the result.
    c_sym       = Expr(:quote,c_name)
    sym_and_lib = :($c_sym, $lib)

    esc(:(function $jlfun($(arguments...))
              Expr(:ccall, $sym_and_lib, $return_type, Expr(:tuple,$(input_types...)), $(argument_names...))
          end))
end

end #module GetC
