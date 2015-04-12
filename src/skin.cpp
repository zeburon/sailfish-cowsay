#include <QFile>
#include <QUrl>

#include "skin.h"

// -----------------------------------------------------------------------

const QString Skin::START_OF_SKIN       = "$the_cow =";
const QString Skin::END_OF_SKIN         = "EOC";
const QString Skin::TAG_EYES1           = "$eyes";
const QString Skin::TAG_EYES2           = "${eyes}";
const QString Skin::TAG_TONGUE1         = "$tongue";
const QString Skin::TAG_TONGUE2         = "${tongue}";
const QString Skin::TAG_THOUGHTS1       = "$thoughts";
const QString Skin::TAG_THOUGHTS2       = "${thoughts}";
const QString Skin::FILENAME_THREE_EYES = "three-eyes";

const int Skin::TEXT_WRAP_LENGTH        = 30;
const QChar Skin::TEXT_WORD_SEPARATOR   = ' ';
const QChar Skin::TEXT_BUBBLE_DISABLED  = ' ';
const QChar Skin::TEXT_BUBBLE_SAY       = '\\';
const QChar Skin::TEXT_BUBBLE_THINK     = 'o';

// -----------------------------------------------------------------------

Skin::Skin(QObject *parent) :
    QObject(parent), m_eyes("oo"), m_supports_eyes(false), m_supports_tongue(false),
    m_thinking(false), m_supports_thinking(false), m_supports_three_eyes(false)
{
}

// -----------------------------------------------------------------------

Skin::~Skin()
{
}

// -----------------------------------------------------------------------

void Skin::setFilename(const QString &filename)
{
    QUrl url(filename);
    QString localFilename = url.toLocalFile();
    if (localFilename != m_filename)
    {
        m_filename = localFilename;
        emit signalFilenameChanged();
        readFromFile();
    }
}

// -----------------------------------------------------------------------

const QString &Skin::getFilename() const
{
    return m_filename;
}

// -----------------------------------------------------------------------

void Skin::setText(const QString &text)
{
    if (text != m_text)
    {
        m_text = text;
        updateTextBubbleString();
        emit signalTextChanged();
        emit signalOutputChanged();
    }
}

// -----------------------------------------------------------------------

const QString &Skin::getText() const
{
    return m_text;
}

// -----------------------------------------------------------------------

void Skin::setEyes(const QString &eyes)
{
    if (eyes != m_eyes)
    {
        m_eyes = eyes;
        emit signalEyesChanged();
        emit signalOutputChanged();
    }
}

// -----------------------------------------------------------------------

const QString &Skin::getEyes() const
{
    return m_eyes;
}

// -----------------------------------------------------------------------

bool Skin::supportsEyes() const
{
    return m_supports_eyes;
}

// -----------------------------------------------------------------------

bool Skin::supportsThreeEyes() const
{
    return m_supports_three_eyes;
}

// -----------------------------------------------------------------------

void Skin::setTongue(const QString &tongue)
{
    if (tongue != m_tongue)
    {
        m_tongue = tongue;
        emit signalTongueChanged();
        emit signalOutputChanged();
    }
}

// -----------------------------------------------------------------------

const QString &Skin::getTongue() const
{
    return m_tongue;
}

// -----------------------------------------------------------------------

bool Skin::supportsTongue() const
{
    return m_supports_tongue;
}

// -----------------------------------------------------------------------

void Skin::setThinking(bool thinking)
{
    if (thinking != m_thinking)
    {
        m_thinking = thinking;
        emit signalThinkingChanged();
        updateTextBubbleString();
        emit signalOutputChanged();
    }
}

// -----------------------------------------------------------------------

bool Skin::isThinking() const
{
    return m_thinking;
}

// -----------------------------------------------------------------------

bool Skin::supportsThinking() const
{
    return m_supports_thinking;
}

// -----------------------------------------------------------------------

QString Skin::getOutput() const
{
    // line / bubbles going from cow to text bubble
    QString thoughts_string;
    if (m_text_bubble_string.isEmpty())
        thoughts_string = TEXT_BUBBLE_DISABLED;
    else
    {
        if (m_thinking)
            thoughts_string = TEXT_BUBBLE_THINK;
        else
            thoughts_string = TEXT_BUBBLE_SAY;
    }

    // special 3-eyes mode extends eyes and tongue string:
    // eyes: e.g. "ooo" instead of "oo"
    // tongue: e.g. "U  " instead of "U "
    QString eyes_string = m_eyes, tongue_string = m_tongue;
    if (m_supports_three_eyes)
    {
        eyes_string += eyes_string[1];

        if (tongue_string[1] == ' ')
            tongue_string.append(' ');
        else
            tongue_string.prepend(' ');
    }

    // replace tags with actual content
    QString result = m_skin_lines.join("");
    result.replace(TAG_EYES1, eyes_string);
    result.replace(TAG_EYES2, eyes_string);
    result.replace(TAG_TONGUE1, tongue_string);
    result.replace(TAG_TONGUE2, tongue_string);
    result.replace(TAG_THOUGHTS1, thoughts_string);
    result.replace(TAG_THOUGHTS2, thoughts_string);

    // merge text bubble with cow
    return m_text_bubble_string + result;
}

// -----------------------------------------------------------------------

void Skin::readFromFile()
{
    QFile file(m_filename);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    m_skin_lines.clear();

    // skip comment lines
    while (!file.atEnd())
    {
        QString line = file.readLine();
        if (line.startsWith(START_OF_SKIN))
            break;
    }

    // read actual content
    while (!file.atEnd())
    {
        QString line = file.readLine();
        if (line.contains(END_OF_SKIN))
            break;

        line.replace("\\\\", "\\");
        m_skin_lines.append(line);
    }

    updateCapabilities();
    emit signalOutputChanged();
}

// -----------------------------------------------------------------------

void Skin::updateCapabilities()
{
    bool supports_eyes = false, supports_tongue = false, supports_thinking = false;
    for (QStringList::const_iterator line_iter = m_skin_lines.begin(); line_iter != m_skin_lines.end(); ++line_iter)
    {
        supports_eyes |= line_iter->contains(TAG_EYES1) || line_iter->contains(TAG_EYES2);
        supports_tongue |= line_iter->contains(TAG_TONGUE1) || line_iter->contains(TAG_TONGUE2);
        supports_thinking |= line_iter->contains(TAG_THOUGHTS1) || line_iter->contains(TAG_THOUGHTS2);
    }
    if (supports_eyes != m_supports_eyes)
    {
        m_supports_eyes = supports_eyes;
        emit signalSupportsEyesChanged();
    }
    if (supports_tongue != m_supports_tongue)
    {
        m_supports_tongue = supports_tongue;
        emit signalSupportsTongueChanged();
    }
    if (supports_thinking != m_supports_thinking)
    {
        m_supports_thinking = supports_thinking;
        emit signalSupportsThinkingChanged();
    }

    // 3-eyes is currently only used by the three-eyes.cow file
    bool supports_three_eyes = m_filename.contains(FILENAME_THREE_EYES);
    if (supports_three_eyes != m_supports_three_eyes)
    {
        m_supports_three_eyes = supports_three_eyes;
        emit signalSupportsThreeEyesChanged();
    }
}

// -----------------------------------------------------------------------

void Skin::updateTextBubbleString()
{
    m_text_bubble_string.clear();
    if (m_text.isEmpty())
        return;

    // apply word wrapping
    QString current_line;
    QStringList text_words = m_text.split(TEXT_WORD_SEPARATOR), text_lines;
    for (QStringList::const_iterator word_iter = text_words.begin(); word_iter != text_words.end(); ++word_iter)
    {
        const QString &current_word = *word_iter;
        if (current_line.isEmpty())
            current_line = current_word;
        else if (current_line.length() + current_word.length() <= TEXT_WRAP_LENGTH)
            current_line += TEXT_WORD_SEPARATOR + current_word;
        else
        {
            text_lines.append(current_line);
            current_line = current_word;
        }
    }
    if (!current_line.isEmpty())
        text_lines.append(current_line);

    // calculate size of text bubble
    int column_count = 0, row_count = text_lines.count(), row = 0;
    for (QStringList::const_iterator line_iter = text_lines.begin(); line_iter != text_lines.end(); ++line_iter)
        column_count = qMax(column_count, line_iter->length());

    // generate text bubble
    m_text_bubble_string = " " + QString(column_count + 2, '_') + "\n";
    for (QStringList::const_iterator line_iter = text_lines.begin(); line_iter != text_lines.end(); ++line_iter, ++row)
    {
        if (m_thinking)
            m_text_bubble_string += "( ";
        else if (row_count == 1)
            m_text_bubble_string += "< ";
        else if (row == 0)
            m_text_bubble_string += "/ ";
        else if (row == row_count - 1)
            m_text_bubble_string += "\\ ";
        else
            m_text_bubble_string += "| ";

        m_text_bubble_string += *line_iter + QString(column_count - line_iter->length(), ' ');

        if (m_thinking)
            m_text_bubble_string += " )\n";
        else if (row_count == 1)
            m_text_bubble_string += " >\n";
        else if (row == 0)
            m_text_bubble_string += " \\\n";
        else if (row == row_count - 1)
            m_text_bubble_string += " /\n";
        else
            m_text_bubble_string += " |\n";

    }
    m_text_bubble_string += " " + QString(column_count + 2, '-') + "\n";
}
