

local f = assert(io.open("test_sereal", "rb"))
local data = f:read("*all")
f:close()

print("\n\nTotal length: " .. string.len(data) .. "\n\n")

local indent = ""

local idx = 1
local data_length = string.len(data)

function varint (idx) {

  local x = 0;
  local lshift = 0;
  while ( idx < data_length and bit32.band(string.byte(data, idx), 0x80 ) )do
    
  end

  my $x = 0;
  my $lshift = 0;
  while (length($data) && ord(substr($data, 0, 1)) & 0x80) {
    my $c = ord(substr($data, 0, 1, ''));
    $done .= chr($c);
    $x += ($c & 0x7F) << $lshift;
    $lshift += 7;
  }
  if (length($data)) {
    my $c = ord(substr($data, 0, 1, ''));
    $done .= chr($c);
    $x += $c << $lshift;
  }
  else {
    die "premature end of varint";
  }
  return $x;
}

function parse_header()
  assert(string.sub(data, idx, 4) == "=srl", "invalid header")
  idx = idx + 4
  local flags = string.sub(data, idx, 1); idx = idx + 1
  local len = varint(idx)
end

parse_header()

while (idx < data_length) do
  -- local $done = parse_sv("")
  print("plop" .. idx)
  idx = idx +1
end

