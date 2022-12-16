#include <list>
#include <iostream>
#include <deque>

class Monkey {
private:
	std::deque<int> items;
	std::string op;
	int increase;
	bool useOld;
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

	void relax(int commonMultiple) {
		if (commonMultiple == 0) {
			float worryLevel = items[0] / 3.0;
			items[0] = (int)std::floor(worryLevel);
		}
		else 
		{
			items[0] %= commonMultiple;
		}
	}

	int nextMonkey() {
		return items[0] % divisible == 0 ? trueMonkey : falseMonkey;
	}

public:
	int id;
	int inspected = 0;
	int divisible;

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

	int inspect(int commonMultiple) {
		if (items.size() > 0) {
			inspected++;
			operation();
			relax(commonMultiple);
			return nextMonkey();
		}

		return -1;
	}

	void catchItem(int item) {
		items.push_back(item);
	}
};
