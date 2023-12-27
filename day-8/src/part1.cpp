#include <iostream>
#include <fstream>
#include <vector>

constexpr const char* START_NODE = "AAA";
constexpr const char* END_NODE = "ZZZ";

enum class Instruction {
    LEFT,
    RIGHT,
};

struct Node {
    std::string name;
    Node* left;
    Node* right;
};

struct Map {
    std::vector<Instruction> instructions;
    Node* root;
};


Map ParseInput(const std::string& path) {
    std::fstream file(path, std::ios::in);

    if (!file.is_open()) {
        std::cout << "Failed to open file: " << path << std::endl;
        exit(1);
    }

    Map map{};

    std::string line;
    std::getline(file, line);
    for (const char& c: line) {
        switch (c) {
        case 'L':
            map.instructions.push_back(Instruction::LEFT);
            break;
        case 'R':
            map.instructions.push_back(Instruction::RIGHT);
            break;
        default:
            std::cerr << "Invalid instruction: " << c << std::endl;
            exit(1);
            break;
        }
    }

    std::vector<Node*> nodes;

    auto FindNode = [&nodes](const std::string& name) -> Node* {
        for (Node* node: nodes) {
            if (node->name == name) {
                return node;
            }
        }

        return nullptr;
    };

    while (std::getline(file, line)) {
        if (line.empty()) {
            continue;
        }

        size_t eq_pos = line.find(" = ");
        std::string name = line.substr(0, eq_pos);

        Node* current_node = FindNode(name);
        if (current_node == nullptr) {
            current_node = new Node {
                .name = name,
                .left = nullptr,
                .right = nullptr,
            };

            nodes.push_back(current_node);
        }

        if (current_node->name == START_NODE) {
            map.root = current_node;
        }

        size_t lb_pos = line.find('(');
        size_t rb_pos = line.find(')');
        size_t comma_pos = line.find(", ");

        std::string left_name = line.substr(lb_pos + 1, comma_pos - lb_pos - 1);
        std::string right_name = line.substr(comma_pos + 2, rb_pos - comma_pos - 2);

        current_node->left = FindNode(left_name);

        if (current_node->left == nullptr) {
            Node* left_node = new Node {
                .name = left_name,
                .left = nullptr,
                .right = nullptr,
            };

            current_node->left = left_node;
            nodes.push_back(left_node);
        }

        current_node->right = FindNode(right_name);

        if (current_node->right == nullptr) {
            Node* right_node = new Node {
                .name = right_name,
                .left = nullptr,
                .right = nullptr,
            };

            current_node->right = right_node;
            nodes.push_back(right_node);
        }
    }

    file.close();

    return map;
}

size_t Solve(const Map& map) {
    Node* current_node = map.root;

    size_t steps = 0;

    size_t instruction_index = 0;
    while (current_node->name != END_NODE) {
        steps++;

        Instruction instruction = map.instructions[instruction_index];
        instruction_index = (instruction_index + 1) % map.instructions.size();

        switch (instruction) {
        case Instruction::LEFT:
            current_node = current_node->left;
            break;
        case Instruction::RIGHT:
            current_node = current_node->right;
            break;
        }
    }

    return steps;
}

int main() {
    Map map = ParseInput("input/input.txt");
    size_t steps = Solve(map);

    std::cout << "Steps: " << steps << std::endl;

    return 0;
}
