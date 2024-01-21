总结：

​	Pearce等人(Pearce et al., 2022)对Copilot进行了一次系统性的代码生成安全评估。他们使用的方法是基于已有的高代码安全风险的场景进行代码生成，例如CWE列表中的漏洞，具体方式是给出一些不完整的代码块作为提示，让Copilot进行代码补全，然后将Copilot代码生成的代码使用CodeQl与手工检查相结合的方式进行安全分析。他们发现Copliot在约40%的情况下会给出有漏洞的代码建议。Majdinasab等人(Majdinasab et al., 2023)对Pearce(Pearce et al., 2022)的工作进行了更新与复现，他们采用了新版本的Copilot和CodeQL，发现Copilot给出有漏洞代码的情况减少了。

​	Prenner等人（Prenner et al. 2022)在大语言模型帮助寻找和修复代码中存在的安全漏洞上做出了工作。他们对Python，Java两种语言进行了探究，使用OpenAI下的Codex模型，对QuixBugs中列出的漏洞进行了代码漏洞修复。他们得出Codex在代码漏洞上相当有效，并且对于Python语言的漏洞修复要高出Java50%。

​	Asmare等人（Asare et al. 2024) 比较了Copilot与人类程序员的代码行为。他们使用了C/C++的漏洞数据集，让Copilot给出代码建议，并分析其是否引入了原始漏洞，或者修补了漏洞。他们发现Copilot有33%的情况给出了包含原始漏洞的代码，有25%的情况给出了修复漏洞的代码，低于人类程序员的比率。他们给出了结论：尽管Copilot对不同漏洞的表现不同，但它在代码生成的安全性方面优于人类开发者。

​	Xu等人（Xu et al., 2022)对于各种开源的与非开源的大语言模型进行了比较评估，包括Codex，GPT-J，GPT-Neo，GPT-NeoX-20B，CodeParrot，以分析非开源模型留下的黑盒知识空白。他们还训练了一个专用于编程的语言模型PolyCoder。研究结果表明，基于GPT-Neo（在自然语言文本上训练）的LLM与基于PolyCoder（只在编程语言上进行训练）的LLM相比，GPT-Neo的性能更好，在自然语言文本和代码上训练的LLM在代码生成工作上可能优于特化的只在代码文本上训练的模型。

​	同时，我们发现了目前关于LLM代码生成安全性的研究都是面向一些通用的高级语言的，如C/C++，Python，Java，而面对特定用途的语言，如HTML, Go语言等的研究明显不足，而我们选择了面向合约的语言solidity进行安全性评估。

​	（这里填充一段solidity介绍的文字）

​	在我们的研究中，我们以solidity为目标语言，对ChatGPT进行了正确性与安全性的评估。过去的讨论(Pearce et al., 2022)大多关注于CGT对主流语言代码生成的可用性与正确性。我们则认为关注大语言模型对于特定目的语言代码生成的安全性评估也是重要的。我们的评估使用了一个solidity的漏洞数据集，以研究ChatGPT在给定问题下是否会产生漏洞代码，以及对漏洞代码的修复能力。





常用代码生成工具：GitHub Copilot，Amazon CodeWhisper，ChatGPT，Tabnine，IntelliCode

Pearce等人在2022年的问题：Does incorporating Copilot, or other CGTs like it, into the software development life cycle render the process of writing software more or less secure?

## Asleep at the Keyboard? Assessing the Security of GitHub Copilot’s Code Contributions

代码生成工具：GitHub Copilot preview version

安全分析框架：CodeQL 2.5.7

研究语言：Python, C, Verilog

研究数据：89个不同的问题情景，1689个测试程序

数据集：https://doi.org/10.5281/zenodo.5225650

研究结论：约40%的程序存在漏洞，Copilot会给出不安全的代码建议

贡献：系统性的研究了可能导致Copilot建议不安全代码的条件，说明了Copilot会给出不安全代码的普遍性

## Assessing the Security of GitHub Copilot's Generated Code - A Targeted Replication Study

代码生成工具：GitHub Copilot 1.77.92

安全分析框架：CodeQL 2.12.4

研究语言：Python

研究数据：12个CWEs，每个29个测试用例

研究结论：Copilot的新版本给出易被攻击的代码建议的频率从36.54%下降到了27.25%，但它仍然在给出不安全的代码建议

贡献：使用新版本Copilot复现了Pearce等人的工作，发现Copilot给出漏洞代码的频率降低了，它正在改善自己的代码安全性

## Is GitHub’s Copilot as Bad as Humans at Introducing Vulnerabilities in Code?

代码生成工具：GitHub Copilot

安全分析框架：人工分析

研究语言：C/C++

研究数据：348个项目，3754个漏洞，4432个测试样例

数据集：https://github.com/ZeoVan/MSR_20_Code_vulnerability_CSV_Dataset

研究结论：总体上Copilot有33%的比例给出了有漏洞的代码，25%的比例给出了修复漏洞的代码，通过对比，Copilot相比于人类程序员更少的给出有漏洞的代码

贡献：探讨了Copilot在代码生成安全性上与人类程序员的比较，并且发现了使用Copilot修复安全漏洞是危险的，有三分之一的样例引入了新漏洞

## Examining Zero-Shot Vulnerability Repair with Large Language Models

提出问题：Can LLMs for code completion help us fix security bugs？大语言模型能用于帮助修复代码的安全漏洞吗？

代码生成工具：

五种商用模型code-cushman-001，code-davinci-001，code-davinci-002，j1-jumbo，j1-large

一种开源模型：polycoder

一种自建模型：gpt2-csrc

安全分析框架：CodeQL 2.7.2

研究对象：零点漏洞，人工制作的（简单场景）和真实存在的（复杂场景）

研究结论：LLM在应对人工构造的简单问题场景时有良好的表现，但在应对真实世界的问题场景时存在挑战

贡献：探讨了多种大语言模型针对特定问题的漏洞修复能力，说明了在复杂应用场景下大语言模型仍存在不足

## Can OpenAI's Codex Fix Bugs?

提出问题：Codex能否发现和修复错误

代码生成工具：Codex

研究语言：Java, Python

研究数据：QuixBugs, 40个Python和Java漏洞

研究结论：与最新技术相比，Codex在未经APR训练的情况下修复漏洞非常有效。在修复Python漏洞上比修复Java漏洞更成功，修复的漏洞多50%

## A Systematic Evaluation of Large Language Models of Code

目标：由于目前最先进的代码大语言模型并不公开，因此对现有的模型进行系统评估

代码生成工具：Codex，GPT-J，GPT-Neo，GPT-NeoX-20B，CodeParrot，PolyCoder

编程语言：12种编程语言

研究结论：在C编程语言中，PolyCoder的表现优于包括Codex在内的所有模型

模型：https://github.com/VHellendoorn/Code-LMs
