import { promises as fs } from "fs"

export async function parseInput(CardType, path) {
    const input = await fs.readFile(path, "utf8");

    const hands = []
    for (const line of input.split("\n")) {
        if (line.trim().length === 0) {
            continue;
        }

        const elements = line.trim().split(" ");
        const cards = elements[0].trim();
        const bid = Number(elements[1].trim());

        const hand = [];
        for (const card of cards)  {
            hand.push(CardType[card]);
        }

        hands.push(Object.freeze({
            cards: hand,
            bid: bid
        }));
    }

    return hands;
}

export function countCards(cards) {
    const counts = {};
    for (const card of cards) {
        if (counts[card] === undefined) {
            counts[card] = 0;
        }

        counts[card] += 1;
    }

    return counts;
}

export function isFiveOfAKind(card_counts) {
    return card_counts[0] === 5;
}

export function isFourOfAKind(card_counts) {
    return card_counts[0] === 4;
}

export function isFullHouse(card_counts) {
    const counts = card_counts;
    return counts[0] === 3 && counts[1] === 2;
}

export function isThreeOfAKind(card_counts) {
    return card_counts[0] === 3;
}

export function isTwoPair(card_counts) {
    return card_counts[0] === 2 && card_counts[1] === 2;
}

export function isPair(card_counts) {
    return card_counts[0] === 2;
}

export function isHighCard(card_counts) {
    return card_counts[0] === 1;
}

export function solve(handValue, hands) {
    hands = [...hands].sort((a, b) => {
        const a_value = handValue(a.cards);
        const b_value = handValue(b.cards);

        if (a_value === b_value) {
            for (let i = 0; i < a.cards.length; i++) {
                if (a.cards[i] !== b.cards[i]) {
                    return a.cards[i] - b.cards[i];
                }
            }
        } else {
            return a_value - b_value;
        }
    })

    let total = 0;
    for (let i = 0; i < hands.length; i++) {
        total += hands[i].bid * (i + 1);
    }

    return total;
}
