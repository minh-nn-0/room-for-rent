#pragma once
#include <cstdint>

namespace rfr
{
	enum class Z_LAYER : int8_t
	{
		BG = 0,
		DEFAULT = 1,
		FG = 2
	};
	struct zindex { int8_t _value;};
};
