// The Ryoku-style desktop clock: Fraunces bone numerals, vermillion 力 seal,
// resting on the wallpaper. "A clock on the wallpaper, and nothing else asking
// for attention." — paper-and-ink design language, adapted from ryoku.dev
//
// Fonts: Fraunces + Noto Sans CJK JP + Space Grotesk (installed via Brewfile).
// A soft black text-shadow stands in for Ryoku's Ink.legible() so the clock
// stays legible on light wallpapers.

export const refreshFrequency = 1000;

export const command = "date +'%H:%M%n%A %d %B'";

export const className = `
  top: auto;
  right: auto;
  bottom: 9%;
  left: 6%;
  font-family: Fraunces, serif;
  font-weight: 300;
  color: #cdc4ba;
  text-shadow: 0 2px 18px rgba(0,0,0,0.75), 0 0 2px rgba(0,0,0,0.5);
  user-select: none;
  line-height: 1;

  .row { display: flex; align-items: baseline; gap: 22px; }
  .time {
    font-size: 132px;
    letter-spacing: 2px;
  }
  .seal {
    font-family: "Noto Sans CJK JP", sans-serif;
    font-size: 40px;
    color: #e2342a;
    text-shadow: 0 2px 10px rgba(0,0,0,0.7);
    transform: translateY(-14px);
  }
  .date {
    font-family: "Space Grotesk", sans-serif;
    font-size: 15px;
    font-weight: 500;
    letter-spacing: 4.5px;
    text-transform: uppercase;
    color: #b0a9a0;
    margin-top: 14px;
    margin-left: 4px;
  }
`;

export const render = ({ output }) => {
  const [time, date] = (output || "").trim().split("\n");
  return (
    <div>
      <div className="row">
        <div className="time">{time}</div>
        <div className="seal">力</div>
      </div>
      <div className="date">{date}</div>
    </div>
  );
};
