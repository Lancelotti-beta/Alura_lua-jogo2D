
idades = { 20, 42, 54, 57, 11, 30, 18 }

for i, idades in ipairs(idades) do 
    print(i, idades)
end

print(" -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ")


fruteira = {"banana", "pera", "melancia", "uva", "abacate", "morango", "maçã"}

for i,fruteira in pairs(fruteira) do
    print(i, fruteira)
end

player = {
    name = "Zero",
    level = 25,
    class = "Ranger",
    arms = {
        "Arco e flecha",
        "Besta",
        "Espada Longa",
        "Escudo"
    },
    itens = "Normal"
}

print("-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ")
for i, player in pairs(player) do 
    print(i, player)
end
