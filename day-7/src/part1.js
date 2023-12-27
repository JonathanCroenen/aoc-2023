import {
    parseInput,
    countCards,
    solve,
    isFiveOfAKind,
    isFourOfAKind,
    isFullHouse,
    isThreeOfAKind,
    isTwoPair,
    isPair,
} from "./common.js";

const CardType = Object.freeze({
    A: 12,
    K: 11,
    Q: 10,
    J: 9,
    T: 8,
    9: 7,
    8: 6,
    7: 5,
    6: 4,
    5: 3,
    4: 2,
    3: 1,
    2: 0,
});



function handValue(cards) {
    const counts = Object.values(countCards(cards)).sort((a, b) => b - a);
    if (isFiveOfAKind(counts)) {
        return 6;
    } else if (isFourOfAKind(counts)) {
        return 5;
    } else if (isFullHouse(counts)) {
        return 4;
    } else if (isThreeOfAKind(counts)) {
        return 3;
    } else if (isTwoPair(counts)) {
        return 2;
    } else if (isPair(counts)) {
        return 1;
    }

    return 0;
}

const hands = await parseInput(CardType, "input/input.txt");
console.log(solve(handValue, hands));
