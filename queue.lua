q = { head = 1, tail = 1 }

function push_queue(v)
  q[q.tail] = v
  q.tail = q.tail + 1
end

function pop_queue()
  if q.head == q.tail then
    q.head = 1
    q.tail = 1
    return nil
  else
    local r = q[q.head]
    q[q.head] = nil
    q.head = q.head + 1
    return r
  end
end
