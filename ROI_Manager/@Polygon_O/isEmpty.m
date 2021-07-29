function Empty = isEmpty(Self)

if length(Self) == 1 && isempty(Self.Name)
    Empty = true;
else
    Empty = false;
end