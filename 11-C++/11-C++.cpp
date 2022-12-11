#include <iostream>
#include <fstream>
#include <sstream>
#include <regex>

#include "Monkey.cpp"

using namespace std;

deque<int> extractInts(string str)
{
	deque<int> res;
	stringstream ss;
	ss << str;
	string temp;
	int found;

	while (!ss.eof()) {
		ss >> temp;
		if (stringstream(temp) >> found)
			res.push_back(found);
		temp = "";
	}

	return res;
}

inline bool ends_with(string const& value, string const& ending)
{
	if (ending.size() > value.size()) return false;
	return std::equal(ending.rbegin(), ending.rend(), value.rbegin());
}

int main()
{
	deque<Monkey> monkies;
	std::ifstream infile("input.txt");

	string line;
	list<deque<int>> monkeyParams;
	string op;
	bool useOld = false;
	while (!infile.eof())
	{
		getline(infile, line);

		// construct monkey
		if (line == "") {
			int monkey = monkeyParams.front().front();
			monkeyParams.pop_front();

			deque<int> startingItems = monkeyParams.front();
			monkeyParams.pop_front();

			int increase = 0;
			if (!useOld) {
				increase = monkeyParams.front().front();
				monkeyParams.pop_front();
			}

			int divisible = monkeyParams.front().front();
			monkeyParams.pop_front();

			int trueMonkey = monkeyParams.front().front();
			monkeyParams.pop_front();

			int falseMonkey = monkeyParams.front().front();
			monkeyParams.pop_front();

			monkies.push_back(Monkey(monkey, startingItems, op, increase, useOld, divisible, trueMonkey, falseMonkey));
			useOld = false;
			continue;
		}

		if (line.find("*") != std::string::npos) {
			op = "*";
		}
		else if (line.find("+") != std::string::npos) {
			op = "+";
		}

		if (ends_with(line, "old")) {
			useOld = true;
		}
		else {
			monkeyParams.push_back(extractInts(line));
		}
	}

	for (int round = 0; round < 10000; round++)
	{
		for (int i = 0; i < monkies.size(); i++)
		{
			//cout << "\nmonkey " << i << "\n";

			while (monkies[i].getItemsSize() > 0)
			{
				// For part one simply pass false to inspect
				int nextMonkey = monkies[i].inspect(false);
				if (nextMonkey != -1) {
					int item = monkies[i].getItem();
					deque<Monkey>::iterator target = find_if(monkies.begin(), monkies.end(), [&](const Monkey& m) { return m.id == nextMonkey; });
					(*target).catchItem(item);

					//cout << "item " << item;
					//cout << " to " << nextMonkey << "\n";
				}
			}

			//cout << "\n";
		}
	}

	for (int i = 0; i < monkies.size(); i++)
	{
		auto m = monkies[i];
		cout << "Monkey " << i << " inspected items " << m.inspected << " times.\n";
	}

	sort(monkies.begin(), monkies.end(), [](const Monkey& a, const Monkey& b) { return a.inspected > b.inspected; });

	cout << monkies[0].inspected * monkies[1].inspected;
}
