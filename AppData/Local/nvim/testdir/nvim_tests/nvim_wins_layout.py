wins = [ "row", [ [ "col", [ [ "row", [ [ "col", [ [ "leaf", 1071 ], [ "leaf", 1070 ] ] ], [ "leaf", 1069 ] ] ], [ "leaf", 1068 ] ] ], [ "leaf", 1000 ] ] ]


second_col = [ [ "leaf", 1071 ], [ "leaf", 1070 ] ]
second_row = [ {'second_col': second_col} , [ "leaf", 1069 ] ]
first_col = [ {'second_row': second_row}, [ "leaf", 1068 ] ]
first_row = [ {'first_col': first_col}, [ "leaf", 1000 ] ]
order_wins = {'first_row': first_row}
print(order_wins)
