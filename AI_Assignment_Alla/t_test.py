%Alla Chepurova
import math


def calc_s(arr, mean):
    s = 0
    for i in arr:
        s += (i - mean) ** 2
    s *= 1 / 9
    return s


def calc_t(arr1, arr2):
    mean1 = sum(arr1) / len(arr1)
    mean2 = sum(arr2) / len(arr2)

    s1 = calc_s(arr1, mean1)
    s2 = calc_s(arr2, mean2)

    t = (mean1 - mean2) / math.sqrt(
        (s1 ** 2 / len(arr1)) + (s2 ** 2 / len(arr2)))
    return t


backtracking = [0.661, 0.585, 0.599, 0.166, 0.049, 0.797, 0.205, 0.001, 0.025, 0.008]
backtracking2 = [0.775, 0.710, 0.697, 0.195, 0.054, 0.945, 0.225, 0.001, 0.029, 0.010]
backtracking_t = calc_t(backtracking, backtracking2)
print("Backtracking time with impovements", backtracking_t)

greedy = [18, 10, 98, 12, 28, 13, 32, 29]
greedy2 = [5, 9, 2, 3, 8, 6, 29, 41]
greedy_t = calc_t(greedy2, greedy)
print("Greedy steps with improvements",greedy_t)

greedy_rand_1 = [1, 1, 1, 1, 1, 5, 45, 1]
greedy_rand_2 = [1, 1, 1, 1, 8, 6, 100, 100]
greedy_rand_t = calc_t(greedy_rand_1, greedy_rand_2)
print("Greedy-random attempts", greedy_rand_t)


rand_rand_improved2 = [1, 3, 1, 3, 23, 1, 100, 100]
rand_rand_improved1 = [1, 1, 1, 3, 1, 37, 80]
rand_rand_improved = calc_t(rand_rand_improved1, rand_rand_improved2)
print("Random-random_improved attempts", rand_rand_improved)

back = [4, 4, 2, 3, 6, 5, 11, 9]
rand = [6, 10, 3, 6, 15, 7]
greed = [22, 14, 6, 6, 16, 7, 36, 23]

back_rand_t = calc_t(back, rand)
back_greed_t = calc_t(back, greed)
rand_greed_t = calc_t(rand, greed)

print("Backtrack vs greedy",back_greed_t)
print("Backtrack vs random",back_rand_t)
print("Random vs greedy", rand_greed_t)
