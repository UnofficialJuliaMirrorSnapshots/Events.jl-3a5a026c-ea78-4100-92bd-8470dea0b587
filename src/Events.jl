module Events

struct Emitter
    listeners::Dict{Symbol,Vector{Function}}
end

Emitter() = Emitter(Dict())

add!(emitter, event::Symbol, f::Function) = begin
    if !haskey(emitter.listeners, event)
        emitter.listeners[event] = []
    end
    push!(emitter.listeners[event], f)
    emitter
end

listeners(emitter, event::Symbol) = haskey(emitter.listeners, event) ?
    emitter.listeners[event] :
    []

on!(f::Function, emitter, event::Symbol) = begin
    add!(emitter, event, f)
    () -> off!(emitter, event, f)
end

off!(emitter, event::Symbol, f::Function) = begin
    if haskey(emitter.listeners, event)
        filter!(emitter.listeners[event]) do f′
            f′ ≠ f
        end
    end
    emitter
end

off!(emitter, event::Symbol) = begin
    delete!(emitter.listeners, event)
    emitter
end

off!(emitter) = begin
    empty!(emitter.listeners)
    emitter
end

emit(emitter, event::Symbol, args...) = begin
    for listener ∈ listeners(emitter, event)
        listener(args...)
    end
end

export
    Emitter,
    add!,
    listeners,
    on!,
    off!,
    emit

end
