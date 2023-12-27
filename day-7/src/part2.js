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
    J: 0,
    T: 9,
    9: 8,
    8: 7,
    7: 6,
    6: 5,
    5: 4,
    4: 3,
    3: 2,
    2: 1,
});

function handValue(cards) {
    // sort the cards by count, then by card value
    const counts = Object.entries(countCards(cards))
        .map(([a, b]) => [Number(a), b])
        .sort((a, b) => {
            if (a[1] === b[1]) {
                return b[0] - a[0];
            }

            return b[1] - a[1];
        });


    // find the most common card in the hand that isn't a jokers
    let mostCommon = counts[0];
    if (mostCommon[0] === CardType["J"]) {
        if (counts.length > 1) {
            mostCommon = counts[1];
        } else {
            // if all cards are jokers, replace them with aces
            mostCommon = CardType["A"];
        }
    }

    // replace the jokers with the most common card (or aces)
    const newCards = cards.map((card) => {
        if (card === CardType["J"]) {
            return mostCommon[0];
        }

        return card;
    });

    // recount the cards
    const newCounts = Object.values(countCards(newCards)).sort((a, b) => b - a);

    // figure out the value of the hand with the best jokers choices applied
    if (isFiveOfAKind(newCounts)) {
        return 6;
    } else if (isFourOfAKind(newCounts)) {
        return 5;
    } else if (isFullHouse(newCounts)) {
        return 4;
    } else if (isThreeOfAKind(newCounts)) {
        return 3;
    } else if (isTwoPair(newCounts)) {
        return 2;
    } else if (isPair(newCounts)) {
        return 1;
    }

    return 0;
}

const hands = await parseInput(CardType, "input/input.txt");
console.log(solve(handValue, hands));
