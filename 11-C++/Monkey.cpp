#include <list>
#include <iostream>
#include <deque>

class Monkey {
private:
	std::deque<int> items;
	std::string op;
	int increase;
	bool useOld;
	int divisible;
	int trueMonkey;
	int falseMonkey;

	void operation() {
		if (op == "*") {
			items[0] = items[0] * (useOld ? items[0] : increase);
		}
		else {
			items[0] = items[0] + (useOld ? items[0] : increase);
		}
	}

	void relax(bool canRelax) {
		if (canRelax) {
			float worryLevel = items[0] / 3.0;
			items[0] = (int)std::floor(worryLevel);
		}
		else 
		{
			int sum = 1;
			for (int item : items)
			{
				sum *= item;
			}
			int worryLevel = items[0] % sum;
			items[0] = (int)std::floor(worryLevel);
		}
	}

	int nextMonkey() {
		return items[0] % divisible == 0 ? trueMonkey : falseMonkey;
	}

public:
	int id;
	int inspected = 0;

	Monkey(int monkey, std::deque<int> startingItems, std::string op, int increase, bool useOld, int divisible, int trueMonkey, int falseMonkey)
	{
		id = monkey;
		items = startingItems;
		this->op = op;
		this->increase = increase;
		this->useOld = useOld;
		this->divisible = divisible;
		this->trueMonkey = trueMonkey;
		this->falseMonkey = falseMonkey;
	}

	int getItemsSize() {
		return items.size();
	}

	int getItem() {
		int i = items.front();
		items.pop_front();
		return i;
	}

	int inspect(bool canRelax) {
		if (items.size() > 0) {
			inspected++;
			operation();
			relax(canRelax);
			return nextMonkey();
		}

		return -1;
	}

	void catchItem(int item) {
		items.push_back(item);
	}
};
