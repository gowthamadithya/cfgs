print('this is a test lua file')
local some_func = function()
  local new_table = { 1, 'some_string', { greet = function() print('this is from greet') end } }
  return new_table
end
local some_table = some_func()
print(some_table[2])



-- metatables
local fib_mt = {
  -- adding meta stuff or similar to object style to a normal table
  __index = function(self, key)
    if key < 2 then return 1 end
    -- hash the table while calculating the results itself
    -- make use of tabulated results to build further series
    self[key] = self[key - 1] + self[key - 2]
    -- return current index result after calculation
    return self[key]
  end
}

-- instance 
local fib_obj = setmetatable({}, fib_mt)

print(fib_obj[10])
print(vim.inspect(fib_obj))
-- using for loop
for key, value in pairs(fib_obj) do
  print(key, value)
end
